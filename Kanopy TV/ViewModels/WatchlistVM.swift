//
//  WatchlistVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

class WatchlistVM: GenericVM {

    private(set) var delegate: WatchlistVCDelegate!
    private(set) var playlist: PlaylistModel!
    private(set) var items: [ItemModel]!
    
    // MARK: - Init method
    
    
    init(delegate: WatchlistVCDelegate!, playlist: PlaylistModel!, items: [ItemModel]!) {
        super.init()
        
        self.delegate = delegate
        self.playlist = playlist
        self.items = items
        
        self.generateSections()
    }
    
    
    // MARK: - Private tools 
    
    
    private func generateSections() {
        
        var cellModels = [GenericCellModel]()
        
        //cellModels.append(self.titleCellModel())
        
        for i in self.items {
            
            let cmd = ChooseItemWatchlistCommand.init(delegate: self.delegate)
            let cm = ItemCellModel.init(item: i,
                                        chooseItemCommand: cmd,
                                        cellID: CollectionCellIDs.videoCollectionCell,
                                        width: 376, height: 224,
                                        focusWidth: 456, focusHeight: 276)

            cellModels.append(cm)
        }
        
        let sm = SectionModel.init(cellModels: cellModels)
        sm.sectionLineSpacing = 80.0
        
        self.sections.append(sm)
    }
    
    
    private func titleCellModel() -> TitleCellModel {
        
        let titleCM = TitleCellModel.init(title: String(self.playlist.itemsCount) + " videos")
        
        return titleCM
    }
}
