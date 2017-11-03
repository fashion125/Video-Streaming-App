//
//  VideoListViewModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/13/17.
//
//

import UIKit

class VideoListViewModel: GenericVM {
    
    var sortBySections: Array<SectionModel> = [SectionModel]()
    var videos: Array<ItemModel> = [ItemModel]()
    
    
    // MARK: - Init methods 
    
    
    override init() {
        super.init()
        
        self.generateSortBySections()
    }
    
    
    // MARK: -
    
    
    /** Method generate sections for sort by table view */
    private func generateSortBySections() {
        
        self.sortBySections = [SectionModel]()
        
        var cellModels = [GenericCellModel]()
        
        cellModels.append(SortItemCellModel.init(title:"RELEVANCE".localized,
                                                 actionKey: SortByActionKey.relevance,
                                                 isSelected: true))
        cellModels.append(SortItemCellModel.init(title: "ALPHABET".localized,
                                                 actionKey: SortByActionKey.alphabet,
                                                 isSelected: false))
        cellModels.append(SortItemCellModel.init(title: "MOST_POPULAR".localized,
                                                 actionKey: SortByActionKey.relevance,
                                                 isSelected: false))
        
        self.sortBySections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    /** Method generate section models for video list */
    open func generateVideoSections(videos: Array<ItemModel>) {
        assertionFailure("Must be implemented in subclasses")
    }
    
    
    /** Method sorts the list videos using key value
     - parameter sortedKey: key value for sort(sort key using with SortByActionKey struct)
     */
    open func sortVideos(sortedKey: String!,
                         completion: (() -> Void)) {
        
        if sortedKey == SortByActionKey.mostPopular {
            
            let vds: NSMutableArray = NSMutableArray.init(array: self.videos)
            
            for it in self.videos {
                if it.popular == true {
                    vds.remove(it)
                    vds.insert(it, at: 0)
                }
            }
            
            let vdsA = vds as NSArray as! [ItemModel]
            self.generateVideoSections(videos: vdsA)
            
        } else if sortedKey == SortByActionKey.relevance {
            self.generateVideoSections(videos: self.videos)
        } else if sortedKey == SortByActionKey.alphabet {
            let sortArray = self.videos.sorted { $0.title < $1.title }
            self.generateVideoSections(videos: sortArray)
        }
        
        completion()
    }
    
    
    /** Method return count for video cells */
    open func countVideos() -> Int32 {
        let sm = self.sections[0]
        
        return Int32(sm.cellModels.count)
    }
    
    
    /** Method unselected all cells, select cell on the index and return new selection cell
     - parameter indexPath: IndexPath for new selction cell
     */
    open func didSelectCell(indexPath: IndexPath!) -> SortItemCellModel {
        
        for sm in self.sortBySections {
            for cm in sm.cellModels {
                let scm: SortItemCellModel = cm as! SortItemCellModel
                scm.updateSelectedType(newSelectedType: false)
            }
        }
        
        let sm = self.sortBySections[indexPath.section]
        let cm: SortItemCellModel = sm.cellModels[indexPath.row] as! SortItemCellModel
        
        cm.updateSelectedType(newSelectedType: true)
        
        return cm
    }
}
