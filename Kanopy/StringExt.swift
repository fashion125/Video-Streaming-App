//
//  StringExt.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import Foundation

extension String {
    
    /** Return string value from localizable file*/
    var localized: String {
        let value:String = NSLocalizedString(self, comment: "")
        return value
    }
    
    
    func character(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    
    static func timeValueWithHours(value: Int32) -> String {

        let seconds: Double = Double.init(value)
        let (hr,  minf) = modf (seconds / 3600)
        let (min, _) = modf (60 * minf)
        let h = Int.init(hr)
        let m = Int.init(min)
        
        var minStr = " mins"
        
        if min == 1 {
            minStr = " min"
        }
        
        var hrStr = " hrs "
        
        if hr == 1 {
            hrStr = " hr "
        }
        
        if h != 0 && m != 0 {
            return String(h) + hrStr + String(m) + minStr
        } else if h == 0 && m != 0 {
            return String(m) + minStr
        } else if h != 0  && m == 0 {
            return String(h) + hrStr
        }
        
        return ""
    }
    
    
    static func timeFormatValueWithoutHours(value: Int32) -> String {
        
        let minutes: Int  = Int(value) / 60
        let seconds: Int  = Int(value) % 60
        
        let str = String.init(format: "%d:%02d", minutes, seconds)
        
        return str
    }
    
    
    static func timeValueWithoutHours(value: Int32) -> String {
        let minutes = value/60
        
        var minStr = " mins"
        
        if minutes == 1 {
            minStr = " min"
        }
        
        return String(minutes) + minStr
    }
    
    
    func bounds(font: UIFont!, containerWidth: CGFloat!) -> CGRect {
        let attrString = NSAttributedString.init(string: self,
                                                 attributes: [NSFontAttributeName : font])
        
        let sizeConstraint = CGSize.init(width: containerWidth, height: CGFloat(Float.greatestFiniteMagnitude))
        
        let boundingRect = attrString.boundingRect(with: sizeConstraint,
                                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   context: nil)
        
        return boundingRect
    }
    
    
    /** Method return label size for string 
     - parameter font: font for attribute string 
     - parameter containerWidth: max width for label
     */
    func height(font: UIFont!, containerWidth: CGFloat!) -> CGFloat {
        
        let attrString = NSAttributedString.init(string: self,
                                                 attributes: [NSFontAttributeName : font])
        
        let sizeConstraint = CGSize.init(width: containerWidth, height: CGFloat(Float.greatestFiniteMagnitude))
        
        let boundingRect = attrString.boundingRect(with: sizeConstraint,
                                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   context: nil)
        
        return boundingRect.size.height
    }
    
    
    // MARK: -
    
    
    /** Method return label size for string
     - parameter font: font for attribute string
     - parameter containerWidth: max width for label
     - parameter lineSpacing: line spacing for label
     */
    func height(width: CGFloat!, font: UIFont!, lineSpacing: CGFloat!) -> CGFloat {
        
        let nstr = NSString.init(string: self)
        let size = CGSize.init(width: width,height: CGFloat(Float.greatestFiniteMagnitude))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let textRect = nstr.boundingRect(with: size,
                                         options: [.usesFontLeading, .usesLineFragmentOrigin],
                                         attributes: [NSFontAttributeName : font,
                                                      NSParagraphStyleAttributeName: paragraphStyle],
                                         context: nil)
        
        return textRect.height
    }
    
    
    // MARK: -
    
    
    func charactersCountInLabel(font: UIFont, size: CGSize!, lineSpacing: CGFloat!) -> Int {
        
        let labelWidth = size.width
        let labelHeight = size.height
        
        let height = self.height(width: labelWidth, font: font, lineSpacing: lineSpacing)
        
        if height >= labelHeight {
            
            var index = 0
            let str: NSString = NSString.init(string: self)
            
            for (i, _) in self.characters.enumerated() {
                
                let s = str.substring(to: index) + "..."
                let height = s.height(width: labelWidth,
                                      font: font,
                                      lineSpacing: lineSpacing)
                
                if labelHeight < height {
                    break
                }
                
                index = i
            }
            
            return index
        }
        
        return self.characters.count
    }
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
        
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    static func baseStringURL() -> String {
        
        if String.buildTypeValue() == "(PROD)" {
            return "https://api.kanopystreaming.com/v1.1/"
        } else if String.buildTypeValue() == "(STAGE)" {
            return "https://stage.kanopystreaming.com/api/v1.1/"
        } else {
            return "https://api.kanopystreaming.com/v1.1/"
        }
    }
    
    
    static func apiKeyForMUXAnalytics() -> String {
        
        if String.buildTypeValue() == "(PROD)" {
            return "AD7A5-eTwrxnhCs5zVREINQb_"
        } else if String.buildTypeValue() == "(STAGE)" {
            return "VAcmCPA0jxkOpVwZtIIqz9HZk"
        } else {
            return "AD7A5-eTwrxnhCs5zVREINQb_"
        }
    }
    
    
    static func versionHeaderValue(device: String) -> String {
        
        let appId = String.appBundleIdentifierValue()
        let version = String.appVersionValue()
        let buildVersion = String.buildVersionValue()
            
        return device + "/" + String(appId) + "/" + String(version) + "/" + String(buildVersion)
    }
    
    
    static func userAgentHeaderValue(device: String) -> String {
        
        let appId = String.appBundleIdentifierValue()
        let version = String.appVersionValue()
        let buildVersion = String.buildVersionValue()
        let deviceName = String.modelName()
        let deviceOsVersion = device + " " + UIDevice.current.systemVersion
        let deviceScale = "Scale/2.00"
        
        return device + "/" + String(appId) + "/" + String(version) + "/" + String(buildVersion) + " (" + String(deviceName) + "; " + String(deviceOsVersion) + "; " + String(deviceScale) + ")"
    }
    
    
    static func appVersionValue() -> String {
        
        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        
        return version
    }
    
    
    static func appBundleNameValue() -> String {
        
        guard let bundleName: String = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return ""
        }
        
        return bundleName
    }
    
    
    static func appBundleIdentifierValue() -> String {
        
        guard let bundleIdentifier: String = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            return ""
        }
        
        return bundleIdentifier
    }
    
    
    static func buildVersionValue() -> String {
        
        guard let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return ""
        }
        
        return buildVersion
    }
    
    
    static func buildTypeValue() -> String {
        
        guard let btv: String = Bundle.main.infoDictionary?["BuildType"] as? String else {
            return ""
        }
        
        if btv == "PROD" {
            return ""
        }
        
        return "("+btv+")"
    }
    
    
    static func concatenate(withFirstValue firstValue: String?,
                            _ secondValue: String?) -> String
    {
        let isHaveFirstValue: Bool = firstValue != nil && (firstValue?.characters.count)! > 0
        let isHaveLastValue: Bool = secondValue != nil && (secondValue?.characters.count)! > 0
        
        if isHaveFirstValue && isHaveLastValue {
            return firstValue! + " " + secondValue!
        }
        
        if !isHaveLastValue && isHaveFirstValue {
            return firstValue!
        }
        
        if !isHaveFirstValue && isHaveLastValue {
            return secondValue!
        }
        
        return ""
    }
    
    
    /** Return name and model of the current device*/
    static func modelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    
    func substring(from: Int) -> String? {
        guard from < self.characters.count else { return nil }
        let fromIndex = index(self.startIndex, offsetBy: from)
        return substring(from: fromIndex)
    }
    
    
    func substring(to: Int) -> String? {
        guard to < self.characters.count else { return nil }
        let toIndex = index(self.startIndex, offsetBy: to)
        return substring(to: toIndex)
    }
    
    func index(string: String, startPos: Index? = nil, options: CompareOptions = .literal) -> Index? {
        let startPos = startPos ?? startIndex
        return range(of: string, options: options, range: startPos ..< endIndex)?.lowerBound
    }
}
