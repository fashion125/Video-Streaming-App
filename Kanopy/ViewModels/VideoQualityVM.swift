//
//  VideoQualityVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/27/17.
//
//

import UIKit

class VideoQualityVM: ChooseItemVM {

    override init(title: String!) {
        super.init(title: title)
        
        self.generateSections()
    }
    
    
    func generateSections() {
        
        var cellModels: Array<GenericCellModel> = []
        
        let vqms = SettingsService.sharedInstance.videoQualityModels
        
        cellModels.append(GenericCellModel.init(TableCellIDs.emptyTableCell, height: 12.0))
        
        for md in vqms! {
            
            let isCheck = SettingsService.sharedInstance.videoQuality() == md.keyValue
            let cm = ChooseItemCellModel.init(title: md.title,
                                              descriptionText: md.descriptionText,
                                              isCheck: isCheck,
                                              keyValue: md.keyValue)
            
            cellModels.append(cm)
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func titleHeaderCellModel() -> TitleCellModel {
        
        let titleCM = TitleCellModel.init(titleValue: "VIDEO_PLAYBACK".localized,
                                          cellID: TableCellIDs.titleHeaderTableCell,
                                          height: 54.0)
        return titleCM
    }
}
