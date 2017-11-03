//
//  SizeStrategy.swift
//  Kanopy
//
//  Created by Boris Esanu on 20.06.17.
//
//

import UIKit

class SizeStrategy: NSObject {

    class func sizeItem() -> CGSize {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return CGSize.init(width: 140.0, height: 79.0)
        } else {
            return CGSize.init(width: 222.0, height: 126.0)
        }
    }

    
    class func shelfCellHeight() -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return 115.0
        } else {
            return 172.0
        }
    }
    
    
    class func shelfTitleFont() -> UIFont {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return UIFont.init(name: "AvenirNextLTPro-Medium", size: 16.0)!
        } else {
            return UIFont.init(name: "AvenirNextLTPro-Medium", size: 21.0)!
        }
    }
    
    
    class func itemTitleFont() -> UIFont {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return UIFont.init(name: "AvenirNextLTPro-Medium", size: 12.0)!
        } else {
            return UIFont.init(name: "AvenirNextLTPro-Medium", size: 14.0)!
        }
    }
    
    
    class func seeMoreButtonFont() -> UIFont {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return UIFont.init(name: "AvenirNextLTPro-Medium", size: 12.0)!
        } else {
            return UIFont.init(name: "AvenirNextLTPro-Medium", size: 16.0)!
        }
    }
    
    
    class func sizeForSearchItem() -> CGSize {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return CGSize.init(width: (UIScreen.main.bounds.width - 38.0)/2.0,
                               height: (UIScreen.main.bounds.width)/3.90)
        } else if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) {
            return CGSize.init(width: (UIScreen.main.bounds.width - 54.0)/4.0,
                               height: ((UIScreen.main.bounds.width - 54.0)/4.0)/1.77)
        } else {
            return CGSize.init(width: (UIScreen.main.bounds.width - 46.0)/3.0,
                               height: ((UIScreen.main.bounds.width - 46.0)/3.0)/1.77)
        }
    }
    
    
    class func sizeLoadCellForSearch() -> CGSize {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return CGSize.init(width: UIScreen.main.bounds.width - 30.0,
                               height: 70.0)
        } else {
            return SizeStrategy.sizeForSearchItem()
        }
    }
    
    
    class func widthForStartWatchingButton() -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return 230
        } else {
            return 400
        }
    }
    
    
    class func authTableViewWidth() -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return UIScreen.main.bounds.width
        } else {
            return UIScreen.main.bounds.width/2
        }
    }
    
    
    class func descriptionCellHeight() -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return 84.0
        } else {
            return 124.0
        }
    }
}
