//
//  AirPlayButton.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/11/17.
//
//

import UIKit
import MediaPlayer

class AirPlayButton: NSObject {

    static let airPlayActiveKey: String = NSNotification.Name.MPVolumeViewWirelessRouteActiveDidChange.rawValue
    
    static let sharedInstance = AirPlayButton()
    
    private(set) var volumeView: MPVolumeView!
    
    
    override init() {
        super.init()
        
        self.createVolumeView()
    }
    
    
    private func createVolumeView() {
        self.volumeView = MPVolumeView.init(frame: CGRect.init(x: 0, y: 2,
                                                                 width: 24.0,
                                                                 height: 24.0))
        self.volumeView?.showsVolumeSlider = false
        self.volumeView?.showsRouteButton = true
        
        self.volumeView?.setRouteButtonImage(UIImage.init(named: "streaming_icon"), for: .normal)
        self.volumeView?.setRouteButtonImage(UIImage.init(named: "selected_streaming_icon"), for: .selected)
        
        self.volumeView.sizeToFit()
    }
}
