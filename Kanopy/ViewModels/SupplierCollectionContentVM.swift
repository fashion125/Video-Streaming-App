//
//  SupplierCollectionContentVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/21/17.
//
//

import UIKit

class SupplierCollectionContentVM: GenericContentVM {

    private(set) var itemsSection: SectionModel!
    
    
    // MARK: - Init methods
    
    
    override init(item: ItemModel!, contentVCDelegate: ContentVCDelegate!) {
        super.init(item: item, contentVCDelegate: contentVCDelegate)
    }
    
    
    // MARK: - Override methods
    
    
    override func headerCellModel() -> GenericCellModel {
        
        let cm = HeaderCellModel.init(name: item.title,
                                      timeValue: self.timeValue(),
                                      ratingCount: self.item.rating.average,
                                      itemTitle: "Video 1",
                                      partTitle: item.items.first?.title,
                                      subtitle: item.tagline,
                                      height: heightForHeaderCell(),
                                      item: self.item,
                                      cellID: TableCellIDs.supplierCollectionHeaderCell)
        
        cm.updateAction { (item: ItemModel?) in
            let it = self.item.items.first
            self.delegate?.didPressToPlayButton(item: it, viewModel: self)
        }
        
        return cm
    }
    
    
    override func infoSection() -> SectionModel {
        
        var cellModels = [GenericCellModel]()
        
        if self.item.filmmakers.count > 0 {
            
            let filmmakersValue = self.item.filmmakers.subjectModelsArrayToString()
            let filmmakersHeight = self.heightInfoCell(title: "FILMMAKERS".localized,
                                                     value: filmmakersValue)
            cellModels.append(InfoCellModel.init(title: "FILMMAKERS".localized,
                                                 value: filmmakersValue,
                                                 height: filmmakersHeight))
        }
        
        
        if item.languages.count > 0 {

            let languageValue = self.item.languages.subjectModelsArrayToString()
            let languageHeight = self.heightInfoCell(title: "LANGUAGES".localized,
                                                     value: languageValue)
            cellModels.append(InfoCellModel.init(title: "LANGUAGES".localized,
                                                 value: languageValue,
                                                 height: languageHeight))
        }
        
        
        if item.cast != nil && item.cast.count > 0  {
            
            let castValue = self.item.cast.subjectModelsArrayToString()
            let castHeight = self.heightInfoCell(title: "CAST".localized,
                                                 value: castValue)
            cellModels.append(InfoCellModel.init(title: "CAST".localized,
                                                 value: castValue,
                                                 height: castHeight))
        }
        
        return SectionModel.init(cellModels: cellModels)
    }
    
    
    override func addOtherSections() {
        
        
    }
    
    
    private func addItemsSection() {
        
        var cellModels = [GenericCellModel]()
        
        cellModels.append(GenericCellModel.init(TableCellIDs.emptyTableCell, height: 8))
        
        for it in self.item.items {
            
            let licm = ListItemCellModel.init(item: it,
                                              actionBlock: { (item: ItemTableCellModel) in
                                                self.delegate?.reloadCell(indexPath: self.cellIndexPath(cellModel: item),
                                                                          viewModel: self)
            })
            
            licm.selectedActionBlock(actionBlock: { (item: ItemModel) in
                self.delegate?.didPressToItem(item: item,
                                              viewModel: self)
            })
            
            cellModels.append(licm)
        }
        
        cellModels.append(GenericCellModel.init(TableCellIDs.emptyTableCell, height: 8))
        
        if self.isCanDownload {
            cellModels.append(GenericCellModel.init(TableCellIDs.loadTableCell, height: 80.0))
        }
        
        if self.itemsSection != nil && self.itemsSection == self.sections.last {
            self.sections.removeLast()
            self.itemsSection = nil
        }
        
        self.itemsSection = SectionModel.init(cellModels: cellModels)
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    override func didLoadVideos(videos: Array<ItemModel>!) {
        self.offset = self.item.items.count
        self.isCanDownload = videos.count == self.limit
        super.genericSections()
        self.addItemsSection()
    }
    
    
    // MARK: - Tools
    
    
    private func heightForHeaderCell() -> CGFloat {
        
        let containerWidth = UIScreen.main.bounds.width - 30.0
        
        let titlefont = UIFont.init(name: "AvenirNextLTPro-Medium", size: 24)
        let titleHeight = self.item.title.height(font: titlefont,
                                        containerWidth: containerWidth)
        
        let partTitlefont = UIFont.init(name: "AvenirNextLTPro-Light", size: 21)
        let partTitleHeight = self.item.items.first?.title.height(font: partTitlefont,
                                                                  containerWidth: containerWidth)
        
        let subTitlefont = UIFont.init(name: "AvenirNextLTPro-Regular", size: 12)
        var subTitleHeight = CGFloat(0)
        
        if self.item.tagline != nil {
            subTitleHeight = (self.item.tagline.height(font: subTitlefont,
                                                       containerWidth: containerWidth))
        }
        
        let margins = CGFloat(76)
        
        return titleHeight + partTitleHeight! + subTitleHeight + margins
    }
    
    
    private func timeValue() -> String {
        
        let itemsCount = self.item.itemsCount
        let episodesStr = itemsCount == 1 ? "VIDEO".localized : "VIDEOS".localized
        
        return String(itemsCount) + " " + episodesStr + " — " + String.timeValueWithoutHours(value: self.item.runningTime)
    }
}
