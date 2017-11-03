//
//  TrackType.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/4/17.
//
//

import Foundation
import AVKit
import AVFoundation

enum TrackType {
    case subtitle
    case audio
    
    /**
     Return valid AVMediaSelectionGroup is item is available.
     */
    public func characteristic(item:AVPlayerItem) -> AVMediaSelectionGroup?  {
        let str = self == .subtitle ? AVMediaCharacteristicLegible : AVMediaCharacteristicAudible
        if item.asset.availableMediaCharacteristicsWithMediaSelectionOptions.contains(str) {
            return item.asset.mediaSelectionGroup(forMediaCharacteristic: str)
        }
        return nil
    }
}
