//
//  PlayMovieScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/1/17.
//
//

import UIKit
import AVKit

protocol PlayMovieScenarioDelegate {
    
}


class PlayMovieScenario: Scenario, PlayerVCDelegate, AVPlayerViewControllerDelegate {
    
    private(set) var item: ItemModel!
    private(set) var rootVC: GenericVC!
    private(set) var delegate: PlayMovieScenarioDelegate!
    private(set) var playerVC: PlayerVC!
    private(set) var playbackDetails: PlaybackDetailsModel?
    private(set) var lastPlayAnalytics: PlayAnalyticsModel!
    
    // MARK: - Init method
    
    
    init(item: ItemModel!, rootVC: GenericVC!, delegate: PlayMovieScenarioDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.item = item
        self.rootVC = rootVC
        
        self.lastPlayAnalytics = PlayAnalyticsModel.init(currentPosition: 0)
    }
    
    
    // MARK: -
    
    
    override func start() {
        self.showPlayerVC()
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: -
    
    
    private func showPlayerVC() {
        self.playerVC = PlayerVC.init(item: self.item, playerVCDelegate: self)
        self.playerVC.delegate = self
        
        self.rootVC.present(self.playerVC, animated: true, completion: nil)
        
        self.sendAnalyticMethod()
    }
    
    
    func sendAnalyticMethod() {
        
        self.loadVideoSources(completion: {
            
            if (self.playbackDetails?.secureURL.characters.count)! > 0 {
                self.playerVC.updateURL(url: URL(string: (self.playbackDetails?.secureURL)!))
                self.checkRecord()
//                self.loadCaptions()
                self.checkPublicCreditsLeft()
            } else {
                UIAlertController.showAlert(title: "CANT_PLAY_VIDEO".localized,
                                            message: "CANT_PLAY_VIDEO_MESSAGE".localized,
                                            fromVC: self.playerVC,
                                            okButton: {
                                                self.playerVC.dismiss(animated: true, completion: nil)
                })
            }
            
            
        }) { (error: ErrorModel) in
            
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.playerVC,
                                        okButton: { 
                                            self.playerVC.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    private func loadVideoSources(completion: @escaping (() -> Void),
                                  failure: @escaping ((ErrorModel) -> Void)) {
        
        VideoService.sharedInstance.analyticsPageView(self.item.itemID, refVideoID: self.item.itemID, completion: { (pageViewID: String) in
            
            self.getPlaybackDetails(pageViewID, completion: completion, failure: failure)
            
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    private func getPlaybackDetails(_ pageViewID: String!,
                                    completion: @escaping (() -> Void),
                                    failure: @escaping ((ErrorModel) -> Void)) {
        
        VideoService.sharedInstance.videoPlaybackDetails(self.item.itemID, pageViewID: pageViewID,
                                                         completion: { (playbackDetails: PlaybackDetailsModel) in
                                                            
                                                            self.playbackDetails = playbackDetails
                                                            completion()
                                                            
        }) { (error: ErrorModel) in
            failure(error)
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
                                            fromVC: self.playerVC)
            })
        }
    }
    
    
    // MARK: - Analytics methods 
    
    // MARK: -
    
    
    func didFinishPlayingVideo(moviePlayerVC: PlayerVC!, item: ItemModel!, isClickedNextView: Bool!) {
        
    }
    
    
    func saveRecord(currentSeconds: Float, item: ItemModel!, moviePlayerVC: PlayerVC!) {
        
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
    
    
    private func createNewAnalyticsEndpoint(_ currentSeconds: Float!) {
        self.lastPlayAnalytics = PlayAnalyticsModel.init(currentPosition: Int(currentSeconds))
    }
    
    
    private func checkRecord() {
        
        if self.playbackDetails?.videoPlayPosition != nil && self.playbackDetails?.videoPlayPosition != 0 {
            
            self.playerVC.player?.pause()
            
            UIAlertController.showAlertWithButtons(title: "RESUME_VIDEO_TV".localized,
                                                   message: "RESUME_PLAYING_WHERE_YOU_LEFT_IT_OFF_TV".localized,
                                                   fromVC: self.playerVC,
                                                   firstButtonTitle: "Resume from " + String.timeFormatValueWithoutHours(value: Int32((self.playbackDetails?.videoPlayPosition)!)),
                                                   secondButtonTitle: "PAY_FROM_START".localized,
                                                   trueButton: {
                                                    
                                                    let seconds = Float64((self.playbackDetails?.videoPlayPosition)!)
                                                    let cmTime = CMTimeMakeWithSeconds(seconds, 1)
                                                    self.playerVC.player?.seek(to: cmTime,
                                                                               toleranceBefore: kCMTimeZero,
                                                                               toleranceAfter: kCMTimeZero,
                                                                               completionHandler: { (isTrue: Bool) in
                                                                                if isTrue {
                                                                                    self.playerVC.player?.rate = 1.0
                                                                                    self.playerVC.player?.play()
                                                                                }
                                                    })
            }, falseButton: { 
                self.playerVC.player?.play()
            })
        } else {
            self.playerVC.player?.play()
        }
    }
    
    
    // MARK: -
    
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willResumePlaybackAfterUserNavigatedFrom oldTime: CMTime, to targetTime: CMTime) {
        
    }
    
    
    func playerViewController(_ playerViewController: AVPlayerViewController, timeToSeekAfterUserNavigatedFrom oldTime: CMTime, to targetTime: CMTime) -> CMTime {
        return targetTime
    }
    
    
    
}
