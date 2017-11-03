//
//  MoviePlayerVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/6/17.
//
//

import UIKit
import AVFoundation
import NMRangeSlider
import SDWebImage
import AVKit
import ASBPlayerSubtitling
import MediaPlayer
import AirPlay
import GoogleCast

protocol MoviePlayerVCDelegate {
    
    /** Method is call when user tap to back button */
    func didPressToBackButton(moviePlayerVC: MoviePlayerVC!)
    
    /** Method is call when movie is ready to play */
    func didReadyToPlay(moviePlayerVC: MoviePlayerVC!, closedCaptions: Array<AVMediaSelectionOption>!)
    
    /** Method is call when movie load is failure */
    func didFailureLoadVideo(moviePlayerVC: MoviePlayerVC!)
    
    /** Method is call when movie is loading */
    func waitingForLoadVideo(moviePlayerVC: MoviePlayerVC!)
    
    /** Method is call when video is finish playing */
    func didFinishPlayingVideo(moviePlayerVC: MoviePlayerVC!, item: ItemModel!, isClickedNextView: Bool!)
    
    func saveRecord(currentSeconds: Float, item: ItemModel!, moviePlayerVC: MoviePlayerVC!)
    
    /** Method is call when user tap to caption button */
    func didPressCaptionButton(moviePlayerVC: MoviePlayerVC!, closedCaptions: Array<AVMediaSelectionOption>!)
    
    /** This method is call when user begin change slider value */
    func didBeginChangeSliderValue(currentSeconds: Float!, moviePlayerVC: MoviePlayerVC!)
    
    /** This method is call when user end change slider value */
    func didEndChangeSliderValue(currentSeconds: Float!, moviePlayerVC: MoviePlayerVC!)
    
    /** This method is call when user did change slider position */
    func didChangeSliderValue(currentSeconds: Float!, movirPlayerVC: MoviePlayerVC!)
    
    /** Method is call when user tap to caption button */
    func didPressChromecastButton(moviePlayerVC: MoviePlayerVC!)
    
    /** Method is call when closed captions is downloaded */
    func didUpdateClosedCaptions(moviePlayerVC: MoviePlayerVC!, closedCaptions: Array<AVMediaSelectionOption>!)
    
    /** This method is call when video player timer did change */
    func didChangeTimer(moviePlayerVC: MoviePlayerVC!)
    
    /** This method is call when user connected or disconnected devices with AirPlay */
    func didChangeScreen(moviePlayerVC: MoviePlayerVC!)

//    /** This method is call when video is start play */
//    func didStartPlayVideo(player: AVPlayer!, moviePlayerVC: MoviePlayerVC!)
}

class MoviePlayerVC: UIViewController, MoviePlayerVMDelegate, RefreshServiceDelegate {
    
    let rateKey: String = "rate"
    let readyForDisplayKey: String = "readyForDisplay"
    let statusKey: String = "status"
    
    
    // MARK: -
    
    @IBOutlet weak var slider: NMRangeSlider!
    @IBOutlet weak var controlPanel: UIView!
    @IBOutlet weak var topControlPanel: UIView!
    @IBOutlet weak var bottomControlPanel: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var playNextView: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playNextLabel: UILabel!
    @IBOutlet weak var captionButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var chromecastButton: UIButton!
    
    @IBOutlet weak var castingToAppleTV: UIImageView!
    @IBOutlet weak var castingToAppleTVLabel: UILabel!
    
    private(set) var airPlayCustomButton: UIButton!
    
    
    private(set) var firstStart: Bool! = false
    
    // MARK: -
    
    private(set) var player: AVPlayer?
    private(set) var playerLayer: AVPlayerLayer!
    private(set) var url: URL!
    
    private(set) var viewModel: MoviePlayerVM!
    private(set) var delegate: MoviePlayerVCDelegate!

    private var isChangeSlider: Bool! = false
    private var isShowStatusBar: Bool! = true
    private(set) var isCanChangeData: Bool = true
    private var timeObserver: AnyObject!
    
    private var playNextTimer: Timer?
    private(set) var playNextTimerSeconds: Float = 0.0
    
    private var tapGesture: UITapGestureRecognizer? = nil
    private var subtitling: ASBPlayerSubtitling?
    @IBOutlet weak var airPlayButtonView: UIView!
    
    private var castingToAirPlay = false
    
    
    // MARK: - Init methods 
    
    
    /** Init method with view model and delegate 
     - parameter viewModel: Model View for Movie player view controller
     - parameter delegate: MoviePlayerVCDelegate object
     */
    init(_ viewModel: MoviePlayerVM!, delegate: MoviePlayerVCDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.viewModel = viewModel
        
        self.addPlayer()
        
        self.view.backgroundColor = UIColor.clear
        self.modalPresentationStyle = .overCurrentContext
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.updateChromeCastButton()
        self.updateAirPlayShareView()
    }
    
    
    /** Required init method */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /** Deinit method */
    deinit {
        
        self.player?.removeObserver(self, forKeyPath: self.rateKey)
        self.playerLayer.removeObserver(self, forKeyPath: self.readyForDisplayKey)
        
        self.player = nil
        self.playerLayer = nil
    }
    
    
    // MARK: - Override methods 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstStart = false
        
        self.backButton.titleLabel?.numberOfLines = 1
        self.backButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.airPlayButtonView.isHidden = true
        
        self.view.backgroundColor = UIColor.clear
        self.updateView(viewModel: self.viewModel)
        
        self.tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(MoviePlayerVC.tapToView))
        self.controlPanel.addGestureRecognizer(self.tapGesture!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ignoreMuteMode()
        self.setupScreen()
        self.registerAirPlayNotifications()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.player?.pause()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RefreshService.sharedInstance.addObserver(observer: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        RefreshService.sharedInstance.removeObserver(observer: self)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.playerLayer.frame = self.view.bounds
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return !self.isShowStatusBar
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Open methods 
    
    
    /** Method show load indicator on the view */
    open func showLoadIndicator() {
        self.loadIndicator.startAnimating()
        self.loadIndicator.isHidden = false
    }
    
    
    /** Method hide load indicator on the view */
    open func hideLoadIndicator() {
        self.loadIndicator.stopAnimating()
        self.loadIndicator.isHidden = true
    }
    
    
    /** Method update url value and start play video 
     - parameter url: URL value for current video
     */
    open func updateURL(url: URL!) {
        
        let playerItem = AVPlayerItem.init(url: url)
        
        if (SettingsService.sharedInstance.videoQuality() == "basic") {
            let maxBitRate = 1400000.0
            
            playerItem.preferredPeakBitRate = maxBitRate
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MoviePlayerVC.errorPlayning), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(MoviePlayerVC.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        if (self.player != nil) {
            self.player?.replaceCurrentItem(with: playerItem)
            self.player?.pause()
            
            if self.delegate != nil {
                self.delegate.didUpdateClosedCaptions(moviePlayerVC: self, closedCaptions: self.getClosedCaptions())
            }
        }
    }
    
    
    /** Method update view model 
     - parameter viewModel: new view model for Movie player view controller
     */
    open func updateView(viewModel: MoviePlayerVM!) {
        
        self.viewModel = viewModel
        self.viewModel.delegate = self
        
        self.captionButton.isHidden = !self.viewModel.isEnabledCaptions
        self.subtitleLabel.isHidden = true
        
        self.chromecastButton.isEnabled = GCKCastContext.sharedInstance().discoveryManager.deviceCount > 0
        
        self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.backButton.setTitle(self.viewModel.titleValue(),
                                 for: .normal)
        self.updateSliderToDefaultSettings()
        
        if !self.playNextView.isHidden {
            self.hidePlayNextView()
        }
        
        self.addTimeObserver()
        self.showPanels()
    }
    
    
    /** This method stops player, enable portrait orientation and call didPressToBackButton method */
    open func closeVC() {
        
        if self.player?.currentItem != nil {
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
            self.delegate.didBeginChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
        }
        
        self.removePlayer()
        self.enablePortraitOrientation {
            self.delegate.didPressToBackButton(moviePlayerVC: self)
        }
    }
    
    
    open func enableSubtitles(closedCaption: AVMediaSelectionOption!) -> Bool {
        
        if self.player == nil || self.player?.currentItem == nil {
            return false
        }
        
        if closedCaption.extendedLanguageTag == nil {
            return true
        }
        
        self.player?.isClosedCaptionDisplayEnabled = true
        let type: TrackType = .subtitle
        let name: String = closedCaption.extendedLanguageTag!
        let group = type.characteristic(item: (self.player?.currentItem)!)
        let matched = group?.options.filter({ $0.extendedLanguageTag == name }).first
            
        self.player?.currentItem?.select(matched, in: group!)
        
        return true
    }
    
    
    open func enableSubtitles(url: URL!) {
        if (self.subtitling != nil) {
            self.subtitling?.removeSubtitles()
        }
        self.subtitling = ASBPlayerSubtitling.init()
        self.subtitling?.player = self.player
        self.subtitling?.label = self.subtitleLabel
        self.subtitling?.loadSubtitles(at: url, error: nil)
    }
    
    
    open func disableSubtitles() {
        
        if self.player == nil || self.player?.currentItem == nil {
            return
        }
        
        self.player?.isClosedCaptionDisplayEnabled = false
        
        let type: TrackType = .subtitle
        let group = type.characteristic(item: (self.player?.currentItem)!)
        
        self.player?.currentItem?.select(nil, in: group!)
    }
    
    
    // MARK: - Tools
    
    
    private func updateChromeCastButton() {
        
        if self.chromecastButton == nil {
            return
        }
        
        self.chromecastButton.isEnabled = false
        //self.chromecastButton.isHidden = GCKCastContext.sharedInstance().discoveryManager.deviceCount == 0
        self.chromecastButton.isHidden = true
    }
    
    
    private func updateAirPlayShareView() {
        
        if self.castingToAppleTV == nil {
            return
        }
        
        self.castingToAppleTV.isHidden = true
        self.castingToAppleTVLabel.isHidden = true
        self.castingToAppleTVLabel.text = "CASTING_TO_APPLE_TV".localized
    }
    
    
    func ignoreMuteMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            // report for an error
        }
    }
    
    
    /** Method is call when user tap to player */
    func tapToView() {
        
        let point = self.tapGesture?.location(in: self.controlPanel)
        
        if !((point?.y)! >= self.bottomControlPanel.frame.origin.y || (point?.y)! <= self.topControlPanel.frame.origin.y + self.topControlPanel.bounds.height) {
            if self.isShowStatusBar == true && !(self.player?.isExternalPlaybackActive)! {
                self.hidePanels()
            } else {
                self.showPanels()
            }
        }
    }
    
    
    /** Method is call when video playing is finished */
    func playerDidFinishPlaying() {
        self.showPanels()
        self.delegate.didFinishPlayingVideo(moviePlayerVC: self, item: self.viewModel.currentItem, isClickedNextView: false)
        
        if self.player?.currentItem != nil {
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
            self.delegate.didBeginChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
        }
    }
    
    
    func errorPlayning() {
        
    }
    
    
    /** Method change device orientation to landscape mode */
    func changeOrientation() {
        self.enableLandscapeOrientation()
    }
    
    
    /** Method add player on the view controller */
    private func addPlayer() {
        
        if self.player == nil {
            self.player = AVPlayer.init()
            self.playerLayer = AVPlayerLayer.init(player: player)
            self.playerLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(self.playerLayer, at: 0)
            self.player?.addObserver(self, forKeyPath: self.rateKey, options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            self.player?.addObserver(self, forKeyPath: self.statusKey, options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            
            self.player?.allowsExternalPlayback = false
        }
    }
    
    
    /** Method add time observer for player*/
    private func addTimeObserver() {
        
        self.removeTimeObserver()
        
        let interval: Double = 0.1
        let timeInterval: CMTime = CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC))
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: timeInterval,
                                                           queue: nil, using: { (time: CMTime) in
                                                            
                                                            if time.value > 0 && self.isCanChangeData {
                                                                
                                                                self.updateTime(self.player?.currentTime(), isSendAnalytics: true)
                                                                self.hideLoadIndicator()
                                                                self.setupScreen()
                                                                
                                                                self.delegate.didChangeTimer(moviePlayerVC: self)
                                                            }
        }) as AnyObject!
    }
    
    
    /** Method remove time observer for player */
    private func removeTimeObserver() {
        
        if self.timeObserver != nil {
            self.player?.removeTimeObserver(self.timeObserver)
            self.timeObserver = nil
        }
    }
    
    
    /** Method update slider to default  value */
    private func updateSliderToDefaultSettings() {
        
        self.slider.lowerHandleHidden = true
        self.slider.stepValueContinuously = false
        
        self.slider.trackBackgroundImage = self.viewModel.backgroundTrackImage
        self.slider.trackImage = self.viewModel.trackImage
        self.slider.upperHandleImageNormal = self.viewModel.thumbImage
        self.slider.upperHandleImageHighlighted = self.viewModel.thumbImage
        self.slider.additionalImageNormal = self.viewModel.bufferTrackImage
        self.slider.isUserInteractionEnabled = false
        
        self.updateTime(CMTimeMake(0, 10), isSendAnalytics: false)
    }

    
    /** Method enable landscape orientation for current view controller */
    private func enableLandscapeOrientation() {
        
        OrientationService.sharedInstance.updateOrientation(.all)
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black
            
        }
    }
    
    
    /** Method enable portrait orientation for current view controller */
    private func enablePortraitOrientation(completion: @escaping (() -> Void)) {
        
        OrientationService.sharedInstance.updateOrientation(.portrait)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            OrientationService.sharedInstance.changeToPortraitOrientation()
            
            self.view.backgroundColor = UIColor.clear
            self.playerLayer.opacity = 0.0
            self.controlPanel.layer.opacity = 0.0
            
        }) { (isTrue: Bool) in
            
            completion()
            
        }
    }
    
    
    /** Method update slider value, time label text value and play button status, show play next view if needed 
     - parameter cmTime: current play video time in CMTime format
     */
    private func updateTime(_ cmTime: CMTime!, isSendAnalytics: Bool!) {
        
        if cmTime == nil {
            return
        }
        
        self.slider.upperValue = self.viewModel.remainingValueForSlider(cmTime: cmTime)
        self.slider.additionalValue = self.viewModel.bufferAvailableValue()
        self.timeLabel.text = self.viewModel.elapsedTimeStringValue(cmTime: cmTime)
        self.updatePlayButton()
        self.view.layoutIfNeeded()
        
        self.viewModel.updateCurrentTime(currentTime: cmTime)
        
        if self.player?.status == .readyToPlay {
            self.updatePlayNextView(cmTime: cmTime)
        }
        
        if isSendAnalytics{
            self.sendAnalytics()
        }
        
        if (self.subtitling != nil) {
            self.subtitling?.playerTimeChanged(with: cmTime)
        }
    }
    
    
    /** This method send analytics to server */
    private func sendAnalytics() {
        
        if self.player?.currentItem != nil {
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
        
            self.delegate.saveRecord(currentSeconds: Float(cs),
                                 item: self.viewModel.currentItem,
                                 moviePlayerVC: self)
        }
    }
    
    
    /** Method update play next view
     - parameter cmTime: current play video time in CMTime format
     */
    private func updatePlayNextView(cmTime: CMTime!) {
        
        if self.viewModel.isShowPlayNext(cmTime) {
            
            if self.playNextView.isHidden {
                self.showPlayNextView()
            }
            
            self.timerLabel.text = self.viewModel.elapsedSecondsStringValue(cmTime: cmTime)
            
        } else if self.playNextView.isHidden == false {
            self.hidePlayNextView()
        }
    }
    
    
    /** Method update play button. If video is play - set pause image, else - set play image*/
    private func updatePlayButton() {
        if self.isPlaying() {
            self.playButton.setImage(self.viewModel.pauseImage, for: .normal)
        } else {
            self.playButton.setImage(self.viewModel.playImage, for: .normal)
        }
    }
    
    
    /** Method update and show play next view*/
    private func showPlayNextView() {
        
        let thumbURL = URL.init(string: (self.viewModel.nextItem.images?.smallThumbURL())!)
        
        self.itemTitleLabel.text = self.viewModel.nextItem.title
        self.thumbImage.sd_setImage(with: thumbURL)
        
        self.addShadowForLabel(label: self.itemTitleLabel)
        self.addShadowForLabel(label: self.timerLabel)
        
        self.playNextView.layer.opacity = 0.0
        self.playNextView.isHidden = false
        
        self.playNextView.layer.shadowRadius = 8
        self.playNextView.layer.shadowOpacity = 0.6
        self.playNextView.layer.shadowColor = UIColor.black.cgColor
        
        UIView.animate(withDuration: 0.5) {
            self.playNextView.layer.opacity = 1.0
        }
    }
    
    
    /** Method hide play next view */
    private func hidePlayNextView() {
        
        UIView.animate(withDuration: 0.5,
                       animations: { 
                        self.playNextView.layer.opacity = 0.0
        }) { (isTrue: Bool) in
            self.playNextView.isHidden = true
        }
    }
    
    
    /** Method show control panels */
    private func showPanels() {
        
        self.isShowStatusBar = true
        
        UIView.animate(withDuration: 0.2) {
            self.topControlPanel.frame = CGRect.init(x: self.topControlPanel.frame.origin.x,
                                                     y: 0,
                                                     width: self.topControlPanel.bounds.width,
                                                     height: self.topControlPanel.bounds.height)
            
            self.bottomControlPanel.frame = CGRect.init(x: self.bottomControlPanel.frame.origin.x,
                                                        y: self.view.frame.height - self.bottomControlPanel.bounds.height,
                                                        width: self.bottomControlPanel.bounds.width,
                                                        height: self.bottomControlPanel.bounds.height)
            self.topControlPanel.layoutIfNeeded()
            self.bottomControlPanel.layoutIfNeeded()
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    /** Method hide control panels */
    private func hidePanels() {
        
        self.isShowStatusBar = false
        
        UIView.animate(withDuration: 0.2) {
            self.topControlPanel.frame = CGRect.init(x: self.topControlPanel.frame.origin.x,
                                                     y: self.topControlPanel.frame.origin.y - self.topControlPanel.bounds.height,
                                                     width: self.topControlPanel.bounds.width,
                                                     height: self.topControlPanel.bounds.height)
            
            self.bottomControlPanel.frame = CGRect.init(x: self.bottomControlPanel.frame.origin.x,
                                                        y: self.view.frame.height + self.bottomControlPanel.bounds.height,
                                                        width: self.bottomControlPanel.bounds.width,
                                                        height: self.bottomControlPanel.bounds.height)
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    /** Method add shadow for label */
    private func addShadowForLabel(label: UILabel!) {
        label.layer.shadowOpacity = 0.4
        label.layer.shadowRadius = 2.0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
    }
    
    
    /** Ovveride observer method */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == self.rateKey {
            self.didReceiveRateNotification()
        } else if keyPath == self.readyForDisplayKey {
        } else if keyPath == self.statusKey {
            self.didReceiveStatusNotification()
        }
    }
    
    
    /** Method return current video is play */
    private func isPlaying() -> Bool {
        return self.player?.rate == Float(1.0)
    }
    
    
    private func didChangeTimeSlider() {
        
        let cmTime: CMTime = self.viewModel.timeWithSliderValue(sliderValue: self.slider.upperValue)
        self.updateTime(cmTime, isSendAnalytics: true)
        
        if self.player != nil && self.player?.currentItem?.status == .readyToPlay {
            
            self.player?.seek(to: cmTime,
                              toleranceBefore: kCMTimeZero,
                              toleranceAfter: kCMTimeZero,
                              completionHandler: { (isTrue: Bool) in
                            
                                if (isTrue) {
                                    self.player?.rate = 1.0
                                    self.player?.play()
                                }
            })
        }
    }
    
    
    private func didReceiveRateNotification() {
        self.updatePlayButton()
    }
    
    
    private func didReceiveStatusNotification() {
        if self.player?.status == .readyToPlay {
            self.slider.isUserInteractionEnabled = true
            self.delegate.didReadyToPlay(moviePlayerVC: self, closedCaptions: self.getClosedCaptions())
        } else if self.player?.status == .unknown {
            self.delegate.waitingForLoadVideo(moviePlayerVC: self)
        } else if self.player?.status == .failed {
            self.showPanels()
            self.delegate.didFailureLoadVideo(moviePlayerVC: self)
        }

    }

    
    // MARK: - MoviePlayerVMDelegate
    
    
    func currentItemDuration(viewModel: MoviePlayerVM!) -> CMTime {
        if self.player?.currentItem != nil {
            return (self.player?.currentItem?.duration)!
        } else {
            return CMTimeMake(0, 1)
            
        }
    }
    
    
    func player(viewModel: MoviePlayerVM!) -> AVPlayer? {
        return self.player
    }
    
    
    func removePlayer() {
        self.player?.pause()
        self.player?.currentItem?.asset.cancelLoading()
        self.player = nil
    }
    
    
    // MARK: -
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    // MARK: - Actions
    
    
    /** Method is call when user tap to back button */
    @IBAction func backButtonAction(_ sender: Any) {
        self.closeVC()
    }
    
    
    /** Method is call when user change slider position */
    @IBAction func didChangeSliderValue(_ sender: Any) {
        
        let cmTime: CMTime = self.viewModel.timeWithSliderValue(sliderValue: self.slider.upperValue)
        self.updateTime(cmTime, isSendAnalytics: true)
    }
    
    
    @IBAction func didBeginChangeSlider(_ sender: Any) {
        
        if self.player?.currentItem != nil {
            self.isCanChangeData = false
            self.player?.pause()
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
            self.delegate.didBeginChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
        }
    }
    
    
    @IBAction func didEndChangeSlider(_ sender: Any) {
        
        if self.player?.currentItem != nil {
            self.isCanChangeData = true
            self.didChangeTimeSlider()
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
            self.delegate.didEndChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
        }
    }
    
    
    /** Method is call when user tap to minus 30 button */
    @IBAction func minus30ButtonAction(_ sender: Any) {
        
        if self.player?.currentItem != nil {
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
            self.delegate.didBeginChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
        }
        
        self.removeTimeObserver()
        
        let cmTime = self.viewModel.minus30secTime()
        self.updateTime(cmTime, isSendAnalytics: true)
        
        self.player?.seek(to: cmTime,
                          toleranceBefore: kCMTimeZero,
                          toleranceAfter: kCMTimeZero,
                          completionHandler: { (isTrue: Bool) in
                            self.addTimeObserver()
                            
                            if self.player?.currentItem != nil {
                                let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
                                self.delegate.didEndChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
                            }
        })
    }
    
    
    /** Method is call when user tap to play/pause button */
    @IBAction func playButtonAction(_ sender: Any) {
        
        if self.isPlaying() {
            self.player?.pause()
            
            if self.player?.currentItem != nil {
                let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
                self.delegate.didBeginChangeSliderValue(currentSeconds: Float(cs), moviePlayerVC: self)
            }
        } else {
            self.player?.play()
        }
        
        self.updatePlayButton()
    }
    
    
    /** Method is call when user tap to play next view */
    @IBAction func playNextButtonAction(_ sender: Any) {
        
        self.showPanels()
        self.hidePlayNextView()
        self.removeTimeObserver()
        self.player?.pause()
        self.player?.currentItem?.asset.cancelLoading()
        self.delegate.didFinishPlayingVideo(moviePlayerVC: self, item: self.viewModel.currentItem, isClickedNextView: true)
    }
    
    
    /** Method is call when user tap to caption button */
    @IBAction func captionButtonAction(_ sender: Any) {
        self.delegate.didPressCaptionButton(moviePlayerVC: self,
                                            closedCaptions: self.getClosedCaptions())
    }
    
    
    // MARK: - AirPlay
    
    
    private func registerAirPlayNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MoviePlayerVC.volumeViewWirelessRoutesAvailableDidChange), name: NSNotification.Name.MPVolumeViewWirelessRoutesAvailableDidChange, object: AirPlayButton.sharedInstance.volumeView)
        NotificationCenter.default.addObserver(self, selector: #selector(MoviePlayerVC.volumeViewWirelessRouteActiveDidChange), name: NSNotification.Name.MPVolumeViewWirelessRouteActiveDidChange, object: AirPlayButton.sharedInstance.volumeView)
    }
    
    
    private func unregisterAirPlayNotifications() {
        AirPlayButton.sharedInstance.volumeView?.removeObserver(self, forKeyPath: NSNotification.Name.MPVolumeViewWirelessRoutesAvailableDidChange.rawValue)
        AirPlayButton.sharedInstance.volumeView?.removeObserver(self, forKeyPath: NSNotification.Name.MPVolumeViewWirelessRoutesAvailableDidChange.rawValue)
    }
    
    
    func volumeViewWirelessRoutesAvailableDidChange() {
        self.viewDidAppear(true)
    }
    
    
    func volumeViewWirelessRouteActiveDidChange() {
        self.player?.play()
        self.delegate.didChangeScreen(moviePlayerVC: self)
    }
    
    
    func setupScreen() {
        
        self.player?.allowsExternalPlayback = true
        self.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        self.slider.isUserInteractionEnabled = true
        AirPlayButton.sharedInstance.volumeView.showsRouteButton = true
        
        self.addStandardAirPlayButton()
        
        self.airplayCastingChanged()
    }
    
    
    /** Method called when the casting state on AirPlay changes */
    open func airplayCastingChanged() {
        
        if self.player == nil {
            return
        }
        
        if (!AirPlayButton.sharedInstance.volumeView.isWirelessRouteActive) || !(self.player?.isExternalPlaybackActive)! {
            castingToAirPlay = false
            self.castingToAppleTV.isHidden = true
            self.castingToAppleTVLabel.isHidden = true
        } else {
            castingToAirPlay = true
            self.castingToAppleTV.isHidden = false
            self.castingToAppleTVLabel.isHidden = false
            self.showPanels()
        }
    }
    
    
    private func removeCustomAirPlayButtonIfNeeded() {
        if self.airPlayCustomButton != nil && self.airPlayButtonView.subviews.contains(self.airPlayCustomButton) {
            self.airPlayCustomButton.removeFromSuperview()
        }
    }
    
    
    private func addCustomAirPlayButton() {
        
        if self.airPlayCustomButton != nil && self.airPlayButtonView.subviews.contains(self.airPlayCustomButton) {
            return
        }
        
        self.airPlayCustomButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: self.airPlayButtonView.bounds.width, height: self.airPlayButtonView.bounds.height))
        self.airPlayCustomButton.setImage(UIImage.init(named: "streaming_icon"), for: .normal)
        self.airPlayCustomButton.addTarget(self, action: #selector(customAirPlayButtonAction), for: .touchUpInside)
        self.airPlayButtonView.isHidden = false
        self.airPlayCustomButton.isUserInteractionEnabled = false
        self.airPlayButtonView.addSubview(self.airPlayCustomButton)
    }
    
    
    private func addStandardAirPlayButton() {
        
        let button = AirPlayButton.sharedInstance.volumeView
        self.airPlayButtonView.frame = CGRect.init(x: 0,
                                                   y: 0,
                                                   width: 60, height: 80)
        button?.frame = CGRect.init(x: 0, y: 2, width: self.airPlayButtonView.bounds.width, height: self.airPlayButtonView.bounds.height)
        self.airPlayButtonView.isHidden = false
        self.airPlayButtonView.addSubview(button!)
    }
    

    /** Method is call when user tap on the ChromeCast button */
    @IBAction func chromecastButtonAction(_ sender: Any) {
        self.delegate.didPressChromecastButton(moviePlayerVC: self)
    }
    
    
    func customAirPlayButtonAction(sender: UIButton!) {
        print("Button tapped")
        
        UIAlertController.showAlert(title: "ERROR".localized,
                                    message: "No nearby devices found. Please check the Internet connection on Apple TV (or other devices).",
                                    fromVC: self)
    }
    
    
    // MARK: - Closed Captions methods 
    
    
    func getClosedCaptions() -> [AVMediaSelectionOption] {
        
        var options = [AVMediaSelectionOption]()
        
        guard let player = self.player else {return options}
        guard let currentItem = player.currentItem else {return options}

        let type: TrackType = .subtitle
        guard let ccs: AVMediaSelectionGroup = type.characteristic(item: currentItem) else {return options}
        
        for option in ccs.options {
            if (option.displayName.characters.count > 0 && option.displayName != "CC") {
                options.append(option)
            }
        }

        return options
    }

    
    // MARK: - RefreshServiceDelegate methods 
    
    
    func appWillEnterForeground() {
        
    }
    
    
    func refreshSideMenu() {
        
    }
}
