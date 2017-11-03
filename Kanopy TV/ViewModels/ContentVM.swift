//
//  ContentVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class ContentVM: GenericVM {

    open var bgThumbURL: URL?
    open var itemModel: ItemModel?
    open var suggestedVideos: Array<ItemModel>?
    private(set) var delegate: GenericContentVCDelegate!
    
    private(set) var buttonsSections: Array<SectionModel>!
    
    
    // MARK: - Init method 
    
    
    init(itemModel: ItemModel?, bgThumbURL: URL?, suggestedVideos: Array<ItemModel>?, delegate: GenericContentVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.bgThumbURL = bgThumbURL
        self.itemModel = itemModel
        self.suggestedVideos = suggestedVideos
        self.buttonsSections = [SectionModel]()
        
        self.checkSuggestedVideos()
        
        if  self.itemModel != nil {
            self.generateButtonSections()
        }
        
    }
    
    
    private func checkSuggestedVideos() {
        
        if (self.suggestedVideos != nil) {
            self.generateSuggestedSections()
        }
    }
    
    
    private func generateSuggestedSections() {
        
        var cellModels = [GenericCellModel]()
        
        for item in self.suggestedVideos! {
            
            let itemCM = ItemCellModel.init(item: item,
                                            chooseItemCommand: ChooseItemContentCommand(delegate: self.delegate),
                                            width: 366,
                                            height: 234)
            
            cellModels.append(itemCM)
        }
        
        let sm = SectionModel.init(cellModels: cellModels)
        sm.sectionLineSpacing = -30
        self.sections.append(sm)
    }
    
    
    private func generateButtonSections() {
        
        var cellModels = [GenericCellModel]()
        
        cellModels.append(self.playButtonCellModel())
        
        if AuthService.sharedInstance.isAuthorized() {
            cellModels.append(self.watchlistButtonCellModel())
        }
        
        cellModels.append(self.showMoreButtonCellModel())
        
        let sm = SectionModel.init(cellModels: cellModels)
        sm.sectionLineSpacing = 10
        self.buttonsSections.append(sm)
    }
    
    
    private func playButtonCellModel() -> GenericCellModel {
        
        let pc = PlayContentCommand.init(delegate: self.delegate)
        let cm = ButtonCollectionCellModel.init(title: "Play".localized,
                                                iconName: "play_tv_icon",
                                                command: pc)
        
        return cm
    }
    
    
    private func watchlistButtonCellModel() -> GenericCellModel {
        
        let title = !(self.itemModel?.isInWatchlist)! ? "Add to Watchlist".localized : "Remove from Watchlist".localized
        let iconName = !(self.itemModel?.isInWatchlist)! ? "add_tv_icon".localized : "remove_tv_icon".localized
        let wc = WatchlistContentCommand.init(delegate: self.delegate)
        let cm = ButtonCollectionCellModel.init(title: title,
                                                iconName: iconName,
                                                command: wc)
        
        return cm
    }
    
    
    private func showMoreButtonCellModel() -> GenericCellModel {
        
        let smc = ShowMoreContentCommand.init(delegate: self.delegate)
        let cm = ButtonCollectionCellModel.init(title: "Show More".localized,
                                                iconName: "show_more_tv_icon",
                                                command: smc)
        
        return cm
    }
}
