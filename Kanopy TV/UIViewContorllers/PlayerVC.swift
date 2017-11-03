//
//  PlayerVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/1/17.
//
//

import UIKit
import AVKit

protocol PlayerVCDelegate {
    
    /** Method is call when video is finish playing */
    func didFinishPlayingVideo(moviePlayerVC: PlayerVC!, item: ItemModel!, isClickedNextView: Bool!)
    
    func saveRecord(currentSeconds: Float, item: ItemModel!, moviePlayerVC: PlayerVC!)
}

class PlayerVC: AVPlayerViewController {

    private(set) var playerVCDelegate: PlayerVCDelegate!
    private(set) var url: URL!
    private var timeObserver: AnyObject!
    private(set) var item: ItemModel!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    // MARK: - Init methods 
    
    
    init(item: ItemModel!, playerVCDelegate: PlayerVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.item = item
        self.playerVCDelegate = playerVCDelegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Open methods 
    
    
    open func updateURL(url: URL!) {
        
        self.url = url
        
        let playerItem = AVPlayerItem.init(url: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerVC.errorPlayning), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerVC.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        self.player = AVPlayer.init(playerItem: playerItem)
        self.player?.play()
        
        self.addTimeObserver()
    }
    
    
    open func showLoadIndicator() {
        self.loadIndicator.isHidden = false
        self.loadIndicator.startAnimating()
    }
    
    
    open func hideLoadIndicator() {
        self.loadIndicator.isHidden = true
        self.loadIndicator.stopAnimating()
    }
    
    
    // MARK: -
    
    
    /** Method add time observer for player*/
    private func addTimeObserver() {
        
        self.removeTimeObserver()
        
        let interval: Double = 0.1
        let timeInterval: CMTime = CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC))
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: timeInterval,
                                                                 queue: nil, using: { (time: CMTime) in
                                                                    
                                                                    if time.value > 0 {
                                                                        
                                                                        self.sendAnalytics()
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
    
    
    func playerDidFinishPlaying() {
        self.playerVCDelegate.didFinishPlayingVideo(moviePlayerVC: self, item: self.item, isClickedNextView: false)
    }
    
    
    func errorPlayning() {
        
    }
    
    
    /** This method send analytics to server */
    private func sendAnalytics() {
        
        if self.player?.currentItem != nil {
            let cs = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
            
            self.playerVCDelegate.saveRecord(currentSeconds: Float(cs),
                                     item: self.item,
                                     moviePlayerVC: self)
        }
    }
}
