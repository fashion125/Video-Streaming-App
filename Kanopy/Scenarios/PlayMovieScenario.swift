//
//  PlayMovieScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/27/17.
//
//

import UIKit
import AVKit
import AVFoundation
import GoogleCast
import MBProgressHUD
import MUXSDKStats

protocol PlayMovieScenarioDelegate {
    
    func didFinishVideoPlaying(playMovieScenario: PlayMovieScenario!, item: ItemModel, isClickedNextView: Bool!)
}


class PlayMovieScenario: Scenario, MoviePlayerVCDelegate, MovieSettingsVCDelegate, WKWebViewVCDelegate, GCKSessionManagerListener, ActivationScenarioDelegate {

    private(set) var currentItem: ItemModel!
    private(set) var nextItem: ItemModel!
    private var playNextTimerSeconds: Float64 = 0
    private var refID: String!
    
    private(set) var captions: [CaptionModel]? = [CaptionModel]()
    private(set) var closedCaptions: [AVMediaSelectionOption]? = [AVMediaSelectionOption]()
    private(set) var currentCaption: AVMediaSelectionOption? = nil
    private(set) var automaticCaption: AVMediaSelectionOption? = nil
    
    
    private(set) var delegate: PlayMovieScenarioDelegate!
    private(set) var genericVC: GenericVC!
    private(set) var moviePlayerVC: MoviePlayerVC!
    private(set) var wkWebViewVC: WKWebViewVC!
    private(set) var playbackDetails: PlaybackDetailsModel?
    private(set) var movieSettingsVC: MovieSettingsVC?
    
    private(set) var isCanSendAnalytics: Bool = true
    private(set) var lastPlayAnalytics: PlayAnalyticsModel!
    
    private(set) var pageViewID: String! = ""
    private(set) var timer: Timer?
    private(set) var counter: Int = 0
    
    private(set) var timerMembership: Timer?
    private(set) var playing: Bool! = false
    
    private(set) var isPlayerView: Bool! = false
    private(set) var isChromecastView: Bool! = false
    
    private(set) var playAt: TimeInterval! = TimeInterval(0)
    
    private(set) var loadingNotification: MBProgressHUD?
    
    private(set) var pollEachNumberOfSeconds = 5
    private(set) var maxMinutesPollingTime = 30
    private(set) var date = Date()
    
    private(set) var activationScenario: ActivationScenario!
    
    private(set) var isCanEnableSubtitle: Bool! = true
    
    
    // MARK: - Init methods
    
    
    init(genericVC: GenericVC!, delegate: PlayMovieScenarioDelegate!, pageViewID: String!) {
        super.init()
        
        self.isCanEnableSubtitle = true
        
        self.genericVC = genericVC
        self.delegate = delegate
        self.pageViewID = pageViewID
        
        self.lastPlayAnalytics = PlayAnalyticsModel.init(currentPosition: 0)
    }
    
    
    // MARK: -
    
    
    /** Start the current scenario. */
    override func start() {
        if (self.isActiveUser()) {
            self.activateMembership()
        } else {
            GCKCastContext.sharedInstance().sessionManager.add(self)
            
            let session = GCKCastContext.sharedInstance().sessionManager
            
            self.playing = true
            self.playAt = TimeInterval(0)
            
            if (session.hasConnectedCastSession()) {
                self.sendMovieToChromecast()
            } else {
                self.showMoviePlayer()
            }
        }
    }
    

    /** Stop the current scenario. */
    override func stop() {
        self.playing = false
    }
    
    
    // MARK: - Open methods
    
    
    open func updatePlaybackDetails(_ pd: PlaybackDetailsModel) {
        self.playbackDetails = pd
    }
    
    
    open func update(_ currentItem: ItemModel!,
                     nextItem: ItemModel?,
                     refNid: String!,
                     playNextTimerSeconds: Float64) {
        
        self.currentItem = currentItem
        self.nextItem = nextItem
        self.refID = refNid
        self.playNextTimerSeconds = playNextTimerSeconds
    }
    
    
    open func playNextVideo() {
        
        let mpVM = MoviePlayerVM.init(currentItem: self.currentItem,
                                      nextItem: self.nextItem,
                                      playNextSeconds: self.playNextTimerSeconds,
                                      isEnabledCaptions: false)
        
        self.moviePlayerVC.updateView(viewModel: mpVM)
        self.sendAnalyticMethod()
    }
    
    
    open func switchToChromecastView() {
        self.isPlayerView = false
        self.isChromecastView = true
    }
    
    
    open func switchToPlayerView() {
        self.isPlayerView = true
        self.isChromecastView = false
    }
    
    
    open func switchToNoView() {
        self.isPlayerView = false
        self.isChromecastView = false
    }
    
    
    // MARK: - Tools 
    
    
    func isActiveUser() -> Bool {
        return AuthService.sharedInstance.user.currentIdentity?.statusKey != "active" && AuthService.sharedInstance.isAuthorized()
    }
    
    
    private func startActivationScenario(withStatusModel: StatusActivationModel) {
        
        self.activationScenario = ActivationScenario.init(authVC: (self.genericVC),
                                                          delegate: self, comingFromLoginScenario: false)
        self.activationScenario.start(withStatusModel: withStatusModel)
    }
    
    
    open func activateMembership() {
        
        let statusModel = AuthService.sharedInstance.statusModel
        
        // If the user has finished his Onboarding process
        if AuthService.sharedInstance.user.identities.count > 0 {
            // If the real current membership is not a National one
            if (AuthService.sharedInstance.user.currentIdentity?.isNotNational())! {
                let title = "MEMBERSHIP".localized + " " + (AuthService.sharedInstance.user.currentIdentity?.statusKey)!
                let description = "PLEASE_REACTIVATE_YOUR_MEMBERSHIP".localized
                
                UIAlertController.showAlert(title: title,
                                            message: description,
                                            fromVC: self.genericVC,
                                            trueButton: {
                                                
                                                AuthService.sharedInstance.checkStatusVerification(userID: AuthService.sharedInstance.user.userID,
                                                                                                   completion: { (statusModel: StatusActivationModel) in
                                                                                     self.didPressToTrueButtonOnAlert(withStatusModel: statusModel)
                                                }, failure: { (error: ErrorModel) in
                                                    
                                                })
                                                
                },
                                            falseButton: {
                                                
                })
            } else {
                // If the real current membership is a National one
                // Asking the user to change his membership with a non National one in his Profile
                UIAlertController.showAlert(title: "Change your membership",
                                            message: "You can change your membership in your profile",
                                            fromVC: self.genericVC,
                                            okButton: {
                                                
                })
            }
        } else {
            // Asking the user to resume his Onboarding Process
            let title = "NO_MEMBERSHIP".localized
            let description = "PLEASE_ADD_AND_ACTIVATE_A_MEMBERSHIP".localized
            
            UIAlertController.showAlert(title: title,
                                        message: description,
                                        fromVC: self.genericVC,
                                        trueButton: {
                                            self.didPressToTrueButtonOnAlert(withStatusModel: statusModel!)
                                            
            },
                                        falseButton: {
                                            
            })
        }
    }
    
    
    /** This method open web view for activate membership */
    open func didPressToTrueButtonOnAlert(withStatusModel: StatusActivationModel) {
        if (!withStatusModel.isVerifyAccount) {
            self.startActivationScenario(withStatusModel: withStatusModel)
        } else {
            let userID = AuthService.sharedInstance.user?.userID
            let destination = "user/"+userID!+"/identities"
            let hashtag = "click:id:button-" + (AuthService.sharedInstance.user.currentIdentity?.domainStem)!
            
            self.wkWebViewVC = WKWebViewVC.init(delegate: self)
            self.genericVC.navigationController?.pushViewController(self.wkWebViewVC, animated: true)
            
            _ = AuthService.sharedInstance.getAutologinUrl(userID: userID, destination: destination, hashtag: hashtag,
                                                           completion: { (url: String) in
                                                            self.wkWebViewVC.updateUrl(url: url)
                                                            self.startTimerMembership()
            }, failure: { (error: ErrorModel) in
                UIAlertController.showAlert(title: error.titleError,
                                            message: error.messageError!,
                                            fromVC: self.genericVC!)
                // We don't show anything for the moment
            })
        }
    }
    
    
    open func showMoviePlayer() {
        self.switchToPlayerView()
        //OrientationService.sharedInstance.updateOrientation(UIInterfaceOrientationMask.landscape)
        
        let mpVM = MoviePlayerVM.init(currentItem: self.currentItem,
                                      nextItem: self.nextItem,
                                      playNextSeconds: self.playNextTimerSeconds,
                                      isEnabledCaptions: false)
        self.moviePlayerVC = MoviePlayerVC.init(mpVM, delegate: self)
        
        self.genericVC.present(self.moviePlayerVC,
                               animated: false) {
        }
        
        self.moviePlayerVC.changeOrientation()
        
        self.sendAnalyticMethod()
    }
    
    
    open func sendMovieToChromecast() {
        self.playing = true
        self.loadingNotification = MBProgressHUD.showAdded(to: self.genericVC.view, animated: true)
        self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
        
        self.switchToChromecastView()
        self.loadVideoSources(completion: {
            self.checkRecordForChromecast()
        }) { (error: ErrorModel) in
            
            self.loadingNotification?.hide(animated: true)
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.moviePlayerVC)
        }
    }
    
    
    func sendAnalyticMethod() {
        
        self.moviePlayerVC.showLoadIndicator()
        
        self.loadVideoSources(completion: {
            
            if (self.playbackDetails?.secureURL.characters.count)! > 0 {
                self.moviePlayerVC.updateURL(url: URL(string: (self.playbackDetails?.secureURL)!))
                
                self.isCanEnableSubtitle = true
                
                self.checkRecord()
                self.checkPublicCreditsLeft()
            } else {
                self.moviePlayerVC.hideLoadIndicator()
                UIAlertController.showAlert(title: "CANT_PLAY_VIDEO".localized,
                                            message: "CANT_PLAY_VIDEO_MESSAGE".localized,
                                            fromVC: self.moviePlayerVC)
            }
            
            
        }) { (error: ErrorModel) in
            
            self.moviePlayerVC.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.moviePlayerVC)
        }
    }
    
    
    private func loadVideoSources(completion: @escaping (() -> Void),
                                  failure: @escaping ((ErrorModel) -> Void)) {
        
        VideoService.sharedInstance.analyticsPageView(self.currentItem.itemID, refVideoID: self.currentItem.itemID, completion: { (pageViewID: String) in
            
            self.getPlaybackDetails(pageViewID, completion: completion, failure: failure)
            
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    private func getPlaybackDetails(_ pageViewID: String!,
                                    completion: @escaping (() -> Void),
                                    failure: @escaping ((ErrorModel) -> Void)) {
        
        VideoService.sharedInstance.videoPlaybackDetails(currentItem.itemID, pageViewID: pageViewID,
        completion: { (playbackDetails: PlaybackDetailsModel) in
            
            self.playbackDetails = playbackDetails
            completion()
            
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    private func checkRecord() {
        
        if self.playbackDetails?.videoPlayPosition != nil && self.playbackDetails?.videoPlayPosition != 0 {
            
            self.moviePlayerVC.player?.pause()
            
            UIAlertController.showAlert(title: "RESUME_PLAYING_WHERE_YOU_LEFT_IT_OFF".localized,
                                        message: "",
                                        fromVC: self.moviePlayerVC,
                                        trueButton: {
                                            
                                            let seconds = Float64((self.playbackDetails?.videoPlayPosition)!)
                                            let cmTime = CMTimeMakeWithSeconds(seconds, 1)
                                            self.moviePlayerVC.player?.seek(to: cmTime,
                                                              toleranceBefore: kCMTimeZero,
                                                              toleranceAfter: kCMTimeZero,
                                                              completionHandler: { (isTrue: Bool) in
                                                                self.moviePlayerVC.player?.rate = 1.0
                                                                self.moviePlayerVC.player?.play()
                                            })
                                            
            },
                                        falseButton: { 
                                            self.moviePlayerVC.player?.play()
            })
        } else {
            self.moviePlayerVC.player?.play()
        }
    }
    
    
    private func checkRecordForChromecast() {
        self.loadingNotification?.hide(animated: true)
        if self.playAt.isZero && self.playbackDetails?.videoPlayPosition != nil && self.playbackDetails?.videoPlayPosition != 0 {
            
            UIAlertController.showAlert(title: "RESUME_PLAYING_WHERE_YOU_LEFT_IT_OFF".localized,
                                        message: "",
                                        fromVC: self.genericVC,
                                        trueButton: {
                                            self.playAt = TimeInterval(CMTimeMakeWithSeconds(Float64((self.playbackDetails?.videoPlayPosition)!), 10).seconds)
                                            self.loadMediaToChromecast()
            },
                                        falseButton: {
                                            self.playAt = TimeInterval(1)
                                            self.loadMediaToChromecast()
            })
        } else {
            self.playAt = TimeInterval(1)
            self.loadMediaToChromecast()
        }
    }
    
    
    private func loadMediaToChromecast() {
        self.loadingNotification = MBProgressHUD.showAdded(to: self.genericVC.view, animated: true)
        self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
        
        if self.playbackDetails != nil && (self.playbackDetails?.secureURL.characters.count)! > 0 {
            self.loadCaptions(completion: {
                self.checkPublicCreditsLeft(completion: {
                    let session = GCKCastContext.sharedInstance().sessionManager.currentCastSession
                    
                    let tokensDescriptionText = self.currentItem.descriptionText.components(separatedBy: "\n")
                    var descriptionText = tokensDescriptionText[0]
                    
                    let maxSize = 200
                    
                    if (descriptionText.characters.count > maxSize) {
                        let rangeDescriptionText = descriptionText.index(descriptionText.startIndex, offsetBy: maxSize)
                        descriptionText = descriptionText.substring(to: rangeDescriptionText)
                    }
                    
                    
                    if (descriptionText != self.currentItem.descriptionText) {
                        descriptionText += "..."
                    }
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let mediaMetadata = GCKMediaMetadata.init()
                    mediaMetadata.setString(self.currentItem.title, forKey: kGCKMetadataKeyTitle)
                    mediaMetadata.setString(descriptionText, forKey: kGCKMetadataKeySubtitle)
                    // Sending app env only for STAGE because PROD is the default
                    if String.buildTypeValue() == "(STAGE)" {
                        mediaMetadata.setString("STAGE", forKey: "envapi")
                    }
                    mediaMetadata.setString(appDelegate.kReceiverAppID, forKey: "appid")
                    mediaMetadata.setString((self.playbackDetails?.videoPlayID)!, forKey: "videoplayid")
                    mediaMetadata.setString(AuthService.sharedInstance.sessionToken!, forKey: "token")
                    
                    let url_roku_medium = NSURL(string:(self.currentItem.images?.roku_medium)!)
                    mediaMetadata.addImage(GCKImage(url: url_roku_medium! as URL, width: 480, height: 360))
                    
                    let mediaStreamtype = GCKMediaStreamType.none
                    
                    var captionsTracks = [GCKMediaTrack]()
            
                    if (self.captions != nil && (self.captions?.count)! > 0) {
                        for i in 0...(self.captions?.count)!-1 {
                            let locale = NSLocale.init(localeIdentifier: (self.captions![i].language))
                            let title = locale.displayName(forKey: NSLocale.Key(rawValue: NSLocale.Key.languageCode.rawValue), value: self.captions![i].language)
                            let titleNS = NSString.init(string: title!)
                            let t = NSString.init(format: "%@%@", titleNS.substring(to: 1).uppercased(), titleNS.substring(from: 1))
                            
                            captionsTracks.append(GCKMediaTrack.init(identifier: i, contentIdentifier: self.captions![i].url_webvtt, contentType: "text/vtt", type: GCKMediaTrackType.text, textSubtype: GCKMediaTextTrackSubtype.captions, name: t as String, languageCode: self.captions![i].language, customData: nil))
                        }
                    }
                    
                    let textTrackStyle  = GCKMediaTextTrackStyle.createDefault()
                    
                    let mediaInfo = GCKMediaInformation.init(contentID: (self.playbackDetails?.secureURL)!, streamType: mediaStreamtype, contentType: "application/vnd.apple.mpegurl", metadata: mediaMetadata, streamDuration: TimeInterval(self.currentItem.runningTime), mediaTracks: captionsTracks, textTrackStyle: textTrackStyle, customData: nil)
                    
                    session?.remoteMediaClient?.loadMedia(mediaInfo, autoplay: true, playPosition: self.playAt)
                    self.loadingNotification?.hide(animated: true)
                })
            })
            
        } else {
            self.loadingNotification?.hide(animated: true)
            UIAlertController.showAlert(title: "CANT_PLAY_VIDEO".localized,
                                        message: "CANT_PLAY_VIDEO_MESSAGE".localized,
                                        fromVC: self.genericVC)
        }
    }
    
    
    private func loadCaptions(completion: @escaping (() -> Void)) {
        
        VideoService.sharedInstance.captions(videoID: self.currentItem.itemID,
                                             completion: { (captions: [CaptionModel]) in
                                                
                                                self.captions = captions
                                                
                                                completion()
                                                
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.moviePlayerVC)
        }
    }
    
    
    private func loadCaptions() {
        
        VideoService.sharedInstance.captions(videoID: self.currentItem.itemID,
        completion: { (captions: [CaptionModel]) in
            
            self.captions = captions
            let vm = MoviePlayerVM.init(currentItem: self.currentItem,
                                        nextItem: self.nextItem,
                                        playNextSeconds: self.playNextTimerSeconds,
                                        isEnabledCaptions: captions.count > 0)
            self.moviePlayerVC.updateView(viewModel: vm)
            self.checkCaptionSettings()
            
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.moviePlayerVC)
        }
    }
    
    
    private func checkPublicCreditsLeft(completion: @escaping (() -> Void)) {
        
        if AuthService.sharedInstance.isHaveCredits() {
            AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
                AuthService.sharedInstance.notifyAllObserversAboutChangePublicCreditsLeft()
                completion()
            }, cacheCompletion: { (user: UserModel) in
                completion()
            }, failure: { (error: ErrorModel) in
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.moviePlayerVC)
            })
        } else {
            completion()
        }
    }
    
    
    private func checkPublicCreditsLeft() {
        
        if AuthService.sharedInstance.isHaveCredits() {
            
            AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
                AuthService.sharedInstance.notifyAllObserversAboutChangePublicCreditsLeft()
            }, cacheCompletion: { (user: UserModel) in
                
            }, failure: { (error: ErrorModel) in
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.moviePlayerVC)
            })
        }
    }
    
    
    private func createNewAnalyticsEndpoint(_ currentSeconds: Float!) {
        self.lastPlayAnalytics = PlayAnalyticsModel.init(currentPosition: Int(currentSeconds))
    }
    
    
    func checkCaptionSettings() {
        
        let count = self.closedCaptions?.count
        
        if !(count! > 0) {
            return
        }
        
        if SettingsService.sharedInstance.closedCaptions() {
            self.currentCaption = self.closedCaptions?.first
        } else {
            self.currentCaption = nil
        }
    }
    
    
    func updateCaptionSettings() {
        
        if self.currentCaption != nil {
            self.enableCaptions(autoPlay: false)
        }
    }
    
    
    func enableCaptions(autoPlay: Bool) {
        
        if self.currentCaption != nil {
            _ = self.moviePlayerVC.enableSubtitles(closedCaption: self.currentCaption)
        } else {
            self.moviePlayerVC.disableSubtitles()
        }
        
        if (autoPlay) {
            self.moviePlayerVC.player?.play()
        }
    }
    
    
    func updateCloseCaptionIcon() {
        
        if self.moviePlayerVC == nil {
            return
        }
        
        let vm = MoviePlayerVM.init(currentItem: self.currentItem,
                                    nextItem: self.nextItem,
                                    playNextSeconds: self.playNextTimerSeconds,
                                    isEnabledCaptions: (self.closedCaptions?.count)! > 0)
        
        self.moviePlayerVC.updateView(viewModel: vm)
    }
    
    
    // MARK: - MoviePlayerVCDelegate methods 
    
    
    func didPressToBackButton(moviePlayerVC: MoviePlayerVC!) {
        
        moviePlayerVC.dismiss(animated: false) {
            OrientationService.sharedInstance.changeToPortraitOrientation()
        }
        
        self.stop()
        OrientationService.sharedInstance.updateOrientation(UIInterfaceOrientationMask.portrait)
        moviePlayerVC.dismiss(animated: false, completion: nil)
    }
    
    
    func didUpdateClosedCaptions(moviePlayerVC: MoviePlayerVC!, closedCaptions: Array<AVMediaSelectionOption>!) {
        
        self.closedCaptions = closedCaptions
        self.updateCloseCaptionIcon()
    }
    
    
    func didReadyToPlay(moviePlayerVC: MoviePlayerVC!, closedCaptions: Array<AVMediaSelectionOption>!) {
        
        self.closedCaptions = closedCaptions
        
        self.sendMuxAnalytics()
        moviePlayerVC.hideLoadIndicator()
        
        self.checkCaptionSettings()
    }
    
    
    func didChangeScreen(moviePlayerVC: MoviePlayerVC!) {
        self.isCanEnableSubtitle = true
    }
    
    
    func didChangeTimer(moviePlayerVC: MoviePlayerVC!) {
        
        if self.currentCaption != nil && self.isCanEnableSubtitle {
            self.isCanEnableSubtitle = !self.moviePlayerVC.enableSubtitles(closedCaption: self.currentCaption)
        }
    }
    
    
    func didFailureLoadVideo(moviePlayerVC: MoviePlayerVC!) {
        moviePlayerVC.hideLoadIndicator()
        UIAlertController.showAlert(title: "ERROR".localized,
                                    message: "Oooops! Can't play video.",
                                    fromVC: moviePlayerVC)
    }
    
    
    func waitingForLoadVideo(moviePlayerVC: MoviePlayerVC!) {
        moviePlayerVC.showLoadIndicator()
    }
    
    
    func didFinishPlayingVideo(moviePlayerVC: MoviePlayerVC!, item: ItemModel!, isClickedNextView: Bool!) {
        self.delegate.didFinishVideoPlaying(playMovieScenario: self, item: item, isClickedNextView: isClickedNextView)
    }
    
    
    func saveRecord(currentSeconds: Float, item: ItemModel!, moviePlayerVC: MoviePlayerVC!) {
    
        let currentValue = Float(currentSeconds*1000)
        let lastValue = Float(self.lastPlayAnalytics.currentPosition*1000)
        
        if currentValue - lastValue >= 10000 {
            self.sendAnalyticsData(currentSeconds: currentSeconds)
        }
    }
    
    
    func sendAnalyticsData(currentSeconds: Float) {
        
        VideoService.sharedInstance.sendAnalytics(videodPlayID: self.playbackDetails?.videoPlayID,
                                                  from: UInt(self.lastPlayAnalytics.currentPosition*1000),
                                                  to: UInt(currentSeconds.checkForNegative*1000))
        
        self.createNewAnalyticsEndpoint(currentSeconds.checkForNegative)
    }
    
    
    func didPressCaptionButton(moviePlayerVC: MoviePlayerVC!, closedCaptions: Array<AVMediaSelectionOption>!) {
        
        self.moviePlayerVC.player?.pause()
        
        self.movieSettingsVC = MovieSettingsVC.init(delegate: self)
        let msVM = MovieSettingsVM.init(closedCaptions: closedCaptions,
                                        selectCaption: self.currentCaption)

        self.moviePlayerVC.present(self.movieSettingsVC!, animated: true, completion: nil)
        self.movieSettingsVC!.updateView(newViewModel: msVM)
    }
    
    
    func didPressChromecastButton(moviePlayerVC: MoviePlayerVC!) {
        self.moviePlayerVC.player?.pause()
        
        self.playAt = TimeInterval((moviePlayerVC.player?.currentItem?.currentTime().seconds)!)
        
        if (GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession()) {
            self.moviePlayerVC.closeVC()
            self.sendMovieToChromecast()
        } else {
            GCKCastContext.sharedInstance().presentCastDialog()
        }
    }
    
    
    func didChooseCaption(indexPath: IndexPath!, movieSettingsVC: MovieSettingsVC!) {
        
        self.movieSettingsVC!.dismiss(animated: true, completion: nil)
        self.currentCaption = movieSettingsVC.viewModel.caption(indexPath: indexPath)
        
        let msVM = MovieSettingsVM.init(closedCaptions: self.closedCaptions,
                                        selectCaption: self.currentCaption)
        movieSettingsVC.updateView(newViewModel: msVM)
        
        self.enableCaptions(autoPlay: true)
    }
    
    
    func didChangeSliderValue(currentSeconds: Float!, movirPlayerVC: MoviePlayerVC!) {
        
    }
    
    
    func didBeginChangeSliderValue(currentSeconds: Float!, moviePlayerVC: MoviePlayerVC!) {
        self.sendAnalyticsData(currentSeconds: currentSeconds)
        self.counter = 0
    }
    
    
    func didEndChangeSliderValue(currentSeconds: Float!, moviePlayerVC: MoviePlayerVC!) {
        self.counter = 0
        self.createNewAnalyticsEndpoint(currentSeconds)
    }
    
    
    // MARK: - MovieSettingsVCDelegate methods
    
    
    func didPressToCloseButton(movieSettingsVC: MovieSettingsVC!) {
        
        self.movieSettingsVC!.dismiss(animated: true) {
            self.moviePlayerVC.player?.play()
        }
    }
    
    
    // MARK: - WKWebViewVCDelegate methods
    
    
    /** This method is called when user tap to back button */
    func didPressBackButton(wkWebViewVC: WKWebViewVC!) {
        self.stopTimerMembership()
        self.genericVC.navigationController?.popViewController(animated: true)
    }
    
    
    /** This method is called when the webview has totally disappeared */
    func webviewDidDisappear(wkWebViewVC: WKWebViewVC!) {
        
    }
    
    
    // MARK: - Timer logic 
    
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(PlayMovieScenario.timerDidEnd), userInfo: nil, repeats: false)
    }
    
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func timerDidEnd() {
        self.isCanSendAnalytics = true
    }
    
    
    func startTimerMembership() {
        // Checking if the timer can be reset
        if (-(self.date.timeIntervalSinceNow)).isLess(than: Double(self.maxMinutesPollingTime*60)) {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.pollEachNumberOfSeconds), target: self, selector: #selector(self.checkMembershipStatus), userInfo: nil, repeats: false)
        }
    }
    
    
    func stopTimerMembership() {
        self.timerMembership?.invalidate()
        self.timerMembership = nil
    }
    
    
    func checkMembershipStatus() {
        let statusModel = AuthService.sharedInstance.statusModel
        
        if (statusModel?.isVerifyAccount)! {
            AuthService.sharedInstance.getMeUser(completion: { (user: UserModel) in
                if (user.currentIdentity?.statusKey == "active") {
                    UIAlertController.showAlert(title: "Membership reactivated",
                                                message: "You can now go back to watching videos",
                                                fromVC: self.wkWebViewVC,
                                                okButton: {
                                                    self.didPressBackButton(wkWebViewVC: self.wkWebViewVC)
                                                    
                    })
                } else {
                    self.startTimerMembership()
                }
                
            }, cacheCompletion: { (user: UserModel) in
            }) { (error: ErrorModel) in }
        }
    }
    
    
    // MARK: - GCKSessionManagerListener Implementations
    
    
    /**
     * Called when a Cast session is about to be started.
     *
     * @param sessionManager The session manager.
     * @param session The session.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKCastSession) {
        for _ in 0...10 {
            print("willStart")
        }
        if (self.playing) {
            self.loadingNotification = MBProgressHUD.showAdded(to: self.genericVC.view, animated: true)
            self.loadingNotification?.mode = MBProgressHUDMode.indeterminate
            self.moviePlayerVC.closeVC()
            self.switchToChromecastView()
            sessionManager.add(self)
        }
    }
    
    
    /**
     * Called when a Cast session has been successfully started.
     *
     * @param sessionManager The session manager.
     * @param session The Cast session.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKCastSession) {
        for _ in 0...10 {
            print("didStart")
        }
        if (!self.playAt.isZero || self.playing) {
            self.loadingNotification?.hide(animated: true)
            self.sendMovieToChromecast()
        }
    }
    
    
    /**
     * Called when a Cast session is about to be ended, either by request or due to an error.
     *
     * @param sessionManager The session manager.
     * @param session The session.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, willEnd session: GCKCastSession) {
        for _ in 0...10 {
            print("willEnd")
        }
        self.switchToNoView()
    }
    
    
    /**
     * Called when a Cast session has ended, either by request or due to an error.
     *
     * @param sessionManager The session manager.
     * @param session The Cast session.
     * @param error The error, if any; otherwise nil.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKCastSession, withError error: Error?) {
        sessionManager.remove(self)
        self.playAt = TimeInterval(0)
        self.stop()
        self.switchToNoView()
        for _ in 0...10 {
            print("didEnd")
        }
    }
    
    
    /**
     * Called when a Cast session has been suspended.
     *
     * @param sessionManager The session manager.
     * @param session The Cast session.
     * @param reason The reason for the suspension.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, didSuspend session: GCKCastSession, with reason: GCKConnectionSuspendReason) {
        for _ in 0...10 {
            print("didSuspend")
        }
    }
    
    
    /**
     * Called when a Cast session is about to be resumed.
     *
     * @param sessionManager The session manager.
     * @param session The session.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, willResumeCastSession session: GCKCastSession) {
        for _ in 0...10 {
            print("willResumeCastSession")
        }
    }
    
    
    /**
     * Called when a Cast session has been successfully resumed.
     *
     * @param sessionManager The session manager.
     * @param session The Cast session.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, didResumeCastSession session: GCKCastSession) {
        for _ in 0...10 {
            print("didResumeCastSession")
        }
    }
    
    
    /**
     * Called when updated device volume and mute state for a Cast session have been received.
     *
     * @param sessionManager The session manager.
     * @param session The Cast session.
     * @param volume The current volume, in the range [0.0, 1.0].
     * @param muted The current mute state.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, castSession session: GCKCastSession, didReceiveDeviceVolume volume: Float, muted: Bool) {
        for _ in 0...10 {
            print("didReceiveDeviceVolume")
        }
    }
    
    
    /**
     * Called when updated device status for a Cast session has been received.
     *
     * @param sessionManager The session manager.
     * @param session The Cast session.
     * @param statusText The new device status text.
     */
    public func sessionManager(_ sessionManager: GCKSessionManager, castSession session: GCKCastSession, didReceiveDeviceStatus statusText: String?) {
        for _ in 0...10 {
            if (statusText != nil) {
                print("didReceiveDeviceStatus " + statusText!)
            } else {
                print("didReceiveDeviceStatus *")
            }
        }
    }
    
    
    // MARK: - Mux Analytics 
    
    
    func sendMuxAnalytics() {

        let playerData: MUXSDKCustomerPlayerData = MUXSDKCustomerPlayerData.init(propertyKey: InjectedMap.apiKeyMUXAnalytics)!
        playerData.viewerUserId = AuthService.sharedInstance.user.userID
        playerData.playerName = "AVPlayer"
        playerData.playerVersion = "1.0"
        
        let videoData = MUXSDKCustomerVideoData.init()
        
        videoData.videoId = self.currentItem.itemID
        videoData.videoTitle = self.currentItem.title
        videoData.videoLanguageCode = self.moviePlayerVC.player?.accessibilityLanguage
        videoData.videoDuration = NSNumber.init(value: Int((self.moviePlayerVC.player?.currentItem?.duration.value)!))
        videoData.videoIsLive = false

        
        MUXSDKStats.monitorAVPlayerLayer(self.moviePlayerVC.playerLayer,
                                         withPlayerName: "awesome",
                                         playerData: playerData,
                                         videoData: videoData)
    }
    
    
    
    // MARK: - ActivateScenarioDelegate methods
    
    
    func stopScenario(scenario: ActivationScenario!) {
        
    }
    
    
    func successfullActivation(_ scenario: ActivationScenario!) {
        scenario.stop()
    }
    
    
    func didPressToSignOutButton(scenario: ActivationScenario!) {
    }
    
    
    func didPressToBackButton(scenario: ActivationScenario!) {
        scenario.activationVC.navigationController?.popViewController(animated: true)
    }
}
