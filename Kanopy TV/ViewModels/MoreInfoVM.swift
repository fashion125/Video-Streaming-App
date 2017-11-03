//
//  MoreInfoVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class MoreInfoVM: GenericVM {

    private(set) var itemModel: ItemModel!
    
    // MARK: - Init methods 
    
    
    init(itemModel: ItemModel!) {
        super.init()
        
        self.itemModel = itemModel
        
        self.generateSection()
    }
    
    
    private func generateSection() {
        
        var cellModels = [GenericCellModel]()
        
        cellModels.append(self.marginTVCellModel(86.0))
        cellModels.append(self.titleCellModel())
        cellModels.append(self.marginTVCellModel(34.0))
        cellModels.append(self.subtitleCellModel())
        cellModels.append(self.ratingCellModel())
        cellModels.append(self.descriptionCellModel())

        if self.itemModel.runningTime != nil && self.itemModel.runningTime > 0 {
            
            let timeCM = ValueCellModel.init(valueText: "RUNNING_TIME".localized,
                                             titleText: String(format: "%02d", lround(Double(self.itemModel.runningTime)) % 60) + " mins")
            cellModels.append(timeCM)
        }

        if self.itemModel.yearOfProduction != nil {
            
            let yearCM = ValueCellModel.init(valueText: "YEAR".localized,
                                             titleText: self.itemModel.yearOfProduction)
            cellModels.append(yearCM)
        }
        
        if self.itemModel.filmmakers.count > 0 {
            
            let filmmakersValue = self.itemModel.filmmakers.subjectModelsArrayToString()
            cellModels.append(ValueCellModel.init(valueText: "FILMMAKERS".localized,
                                                  titleText: filmmakersValue))
        }
        
        if itemModel.director != nil && itemModel.director.count > 0 {
            
            let directorValue = itemModel.director.joined(separator: ",")
            
            cellModels.append(ValueCellModel.init(valueText: "DIRECTOR".localized,
                                                  titleText: directorValue))
        }
        
        
        if itemModel.cast.count > 0  {
            
            let castValue = itemModel.cast.subjectModelsArrayToString()
            cellModels.append(ValueCellModel.init(valueText: "CAST".localized,
                                                  titleText: castValue))
        }
        
        
        if itemModel.languages.count > 0 {
            
            let languageValue = itemModel.languages.subjectModelsArrayToString()
            cellModels.append(ValueCellModel.init(valueText: "LANGUAGES".localized,
                                                  titleText: languageValue))
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    private func titleCellModel() -> GenericCellModel {
        let cm = TextCellModel.init(text: itemModel.title,
                                    font: UIFont.systemFont(ofSize: 57.0),
                                    color: UIColor.white)
        
        return cm
    }
    
    
    private func subtitleCellModel() -> GenericCellModel {
        
        let cm = TextCellModel.init(text: self.itemModel.tagline != nil ? itemModel.tagline : "",
                                    font: UIFont.systemFont(ofSize: 38.0),
                                    color: UIColor.white)
        
        return cm
    }
    
    
    private func descriptionCellModel() -> GenericCellModel {
        let cm = TextCellModel.init(text: itemModel.descriptionText,
                                    font: UIFont.systemFont(ofSize: 29.0),
                                    color: UIColor.white)
        
        return cm
    }
    
    
    private func ratingCellModel() -> GenericCellModel {
        let cm = RatingCellModel.init(ratingCount: self.itemModel.rating.average,
                                      isHaveCaption: self.itemModel.hasCaptions)
        
        return cm
    }
}
