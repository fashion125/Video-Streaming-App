//
//  LinkYourRokuVM.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 01/06/2017.
//
//

import UIKit

class LinkYourRokuVM: GenericVM {
    
    private(set) var delegate: LinkYourRokuVCDelegate!
    private(set) var title: String!
    
    // MARK: - Init method
    
    
    init(title: String!, delegate: LinkYourRokuVCDelegate!) {
        super.init()
        
        self.title = title
        self.delegate = delegate
        
        self.generateSections()
    }
    
    
    func generateSections() {
        
        var cellModels: Array<GenericCellModel> = []
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 17.0)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.35 * font.lineHeight
        paragraphStyle.alignment = .center
        
        let attrs = [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : UIColor.white,
            NSParagraphStyleAttributeName: paragraphStyle]
        let ta = NSAttributedString.init(string: "ENTER_THE_CODE_DISPLAYED_ON_YOUR_TV_ROKU".localized,
                                         attributes: attrs)
        cellModels.append(TextCellModel.init(textAttribute: ta, height: 140.0))
        
        let text = TextFieldCellModel.init(placeholder: "CODE".localized, value: "", iconImage: nil, isSecretField: false)
        let validateRokuCode = ValidateRokuCode.init(delegate: self.delegate, textFieldCellModel: text)
        text.updateReturnClickedCommand(returnClickedCommand: validateRokuCode)
        cellModels.append(text)
        
        cellModels.append(GenericCellModel.init(TableCellIDs.emptyTableCell, height: 20.0))
        
        let openUrlCommand = OpenUrlCommand.init(url: "https://channelstore.roku.com/details/122409/kanopy")
        cellModels.append(ButtonCellModel.init(title: "DONT_HAVE_KANOPY_ON_ROKU_CLICK_HERE_TO_ADD_IT".localized,
                                               font: UIFont.init(name: "AvenirNextLTPro-Medium", size: 16.0),
                                               color: UIColor.white,
                                               buttonCommand: openUrlCommand,
                                               cellID: TableCellIDs.titleButtonTableCell,
                                               isUnderline: true,
                                               height: 40.0))
        
        let buttonCellModel = ButtonCellModel.init(title: "LINK_TO_MY_ACCOUNT".localized, buttonCommand: validateRokuCode, cellID: TableCellIDs.buttonTableCell, height: 140.0)
        cellModels.append(buttonCellModel)
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
}

