//
//  ReadMoreLabel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/20/17.
//
//

import UIKit

class ReadMoreLabel: UILabel {

    private(set) var showMoreTextAttr: NSAttributedString?
    private(set) var showLessTextAttr: NSAttributedString?
    
    private(set) var tapActionBlock: (() -> Void)!
    private(set) var showAttribute: NSAttributedString?
    private(set) var width: CGFloat = 0.0
//    private(set) var numberOfLinesForLess: Int = 3
    
    
    // MARK: - Init methods 
    
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 300.0, height: 20.0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Open methods 
    
    
    /** Method update number of lines for less type
     - parameter numberOfLines: New Number of lines value
     */
    open func updateNumberOfLinesForLess(numberOfLines: Int) {
        //self.numberOfLinesForLess = numberOfLines
    }
    
    
    /** Method update show more text attribute 
     - parameter newShowMoreTextAttribute: New Show More text attribute value
     */
    open func updateShowMoreTextAttribute(_ newShowMoreTextAttribute: NSAttributedString!) {
        self.showMoreTextAttr = newShowMoreTextAttribute
    }
    
    
    /** Method update show less text attribute
     - parameter newShowLessTextAttribute: New Show Less text attribute value
     */
    open func updateShowLessTextAttribute(_ newShowLessTextAttribute: NSAttributedString!) {
        self.showLessTextAttr = newShowLessTextAttribute
    }
    
    
    /** Method show 'Show More' or 'Show Less' button on the label if needed
     - parameter isShow: if label show all text value = true, else = false
     - parameter width: label's width value 
     - paarameter tapAction: Action block for tap to label
     */
    open func showButton(_ isShow: Bool!, width: CGFloat!, tapAction: (() -> Void)!) {
        
        self.tapActionBlock = tapAction
        self.width = width
        
        if (self.text?.characters.count)! > 0 {
            self.updateLabelSize(isShow: isShow)
            self.addReadMoreStringToLabel(isShow)
        }
    }
    
    
    // MARK: - Tools
    
    
    private func updateLabelSize(isShow: Bool!) {
        if isShow == false {
            self.numberOfLines = 0
        } else {
            self.numberOfLines = self.numberOfLinesForLess()
        }
        
        self.sizeToFit()
    }
    
    
    private func numberOfLinesForLess() -> Int {
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad) {
            return 3
        } else {
            return 5
        }
    }
    
    private func addReadMoreStringToLabel(_ isShow: Bool) {
        
//        let queue = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.userInitiated)
        
//        queue.async {
        self.showAttribute = self.showLessAttributeStr()
        
        if isShow {
            self.showAttribute = self.showMoreAttributeStr()
        }
        
        let lenghtForString = self.text?.characters.count
        let lengthForVisibleString = self.charactersCountInLabel(fitString: self.text!, label: self)
        let mutableString = NSMutableString.init(string: self.text!)
        
        if (isShow) {
            mutableString.replaceCharacters(in: NSRange.init(location: Int(lengthForVisibleString), length: (lenghtForString! - lengthForVisibleString)), with: "")
            mutableString.append("...")
        }
        
        let answerAttributed = NSMutableAttributedString.init(string: mutableString as String,
                                                              attributes: [NSFontAttributeName : self.font])
        answerAttributed.append(self.showAttribute!)
        
            DispatchQueue.main.async {
                self.attributedText = answerAttributed
            }
    
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ReadMoreLabel.tapToLabel))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
//        }
    }
    
    
    func charactersCountInLabel(fitString: String, label: UILabel) -> Int {
        
        let labelWidth = self.width
        let labelHeight = label.frame.size.height
        
        let sizeConstraint = CGSize.init(width: labelWidth, height: CGFloat(Float.greatestFiniteMagnitude))
        
        let attrString = NSAttributedString.init(string: fitString,
                                                 attributes: [NSFontAttributeName : self.font!])
        
        let boundingRect = attrString.boundingRect(with: sizeConstraint,
                                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   context: nil)
        
        if boundingRect.size.height >= labelHeight {
            
            var index = 0
            
            let str: NSString = NSString.init(string: fitString)
            
            for (i, _) in fitString.characters.enumerated() {
                
                let height = self.height(str: str, index: i, size: sizeConstraint)
                
                if labelHeight < height {
                    break
                }
                
                index = i
            }
            
            return index
        }
        
        return fitString.characters.count
    }
    
    
    func height(str: NSString!, index: Int!, size: CGSize!) -> CGFloat {
        
        let string = str.substring(to: index) + "... " + (self.showAttribute?.string)!
        let constraintRect = CGSize(width: size.width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: self.font], context: nil)
        
        return boundingBox.height
    }
    
    
    /** Method return NSAttributedString for 'Show More' button */
    private func showMoreAttributeStr() -> NSAttributedString {
        
        if  self.showMoreTextAttr == nil {
            
            let rmAs = NSMutableAttributedString.init(string: " " + "SHOW_MORE".localized)
        
            rmAs.addAttribute(NSForegroundColorAttributeName, value: UIColor.mainOrangeColor(), range: NSRange.init(location: 0, length: rmAs.string.characters.count))
            rmAs.addAttribute(NSFontAttributeName, value: UIFont.init(name: "AvenirNextLTPro-Regular", size: 15.0)!, range: NSRange.init(location: 0, length: rmAs.string.characters.count))
        
            return rmAs
            
        } else {
            return self.showMoreTextAttr!
        }
    }
    
    
    /** Method return NSAttributedString for 'Show Less' button */
    private func showLessAttributeStr() -> NSAttributedString {
        
        if self.showLessTextAttr == nil {
            
            let rmAs = NSMutableAttributedString.init(string: "SHOW_LESS".localized)
        
            rmAs.addAttribute(NSForegroundColorAttributeName, value: UIColor.mainOrangeColor(), range: NSRange.init(location: 0, length: rmAs.string.characters.count))
            rmAs.addAttribute(NSFontAttributeName, value: UIFont.init(name: "AvenirNextLTPro-Regular", size: 15.0)!, range: NSRange.init(location: 0, length: rmAs.string.characters.count))
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .right
            
            rmAs.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSRange.init(location: 0, length: rmAs.string.characters.count))
            
            return rmAs
            
        } else {
            return self.showLessTextAttr!
        }
    }
    
    
    // MARK: - Actions 
    
    
    /** Method is call when user tap to label */
    func tapToLabel() {
        self.tapActionBlock()
    }
}
