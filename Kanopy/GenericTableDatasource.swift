//
//  GenericDatasource.swift
//  optum-soft-install-app
//
//  Created by Ilya Katrenko on 9/26/16.
//  Copyright © 2016 Design and Test Lab. All rights reserved.
//

import UIKit

protocol GenericDataSourceDelegate {
    
    func didPressToCell(with indexPath:IndexPath!, dataSource: GenericTableDatasource!)
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!)
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!)
}

class GenericTableDatasource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private(set) var sectionModels: [SectionModel] = []
    public var delegate: GenericDataSourceDelegate?
    public var canFocus: Bool! = false
    
    init(sections: Array<SectionModel>!) {
        super.init()
        
        self.sectionModels = sections
    }
    
    
    func updateSectionModels(sections: Array<SectionModel>!) {
        self.sectionModels = sections
    }
    
    // MARK: - UITableView
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sm: SectionModel = self.sectionModels[section]
        return sm.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sm: SectionModel = self.sectionModels[indexPath.section]
        let cm: GenericCellModel = sm.cellModels[indexPath.row]
        let cell: GenericCell = tableView.dequeueReusableCell(withIdentifier: cm.cellID, for: indexPath) as! GenericCell
        cell.configure(cellModel: cm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sm: SectionModel = self.sectionModels[indexPath.section]
        let cm: GenericCellModel = sm.cellModels[indexPath.row]
        return cm.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sm: SectionModel = self.sectionModels[section]
        return sm.headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sm: SectionModel = self.sectionModels[section]
        return sm.footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didPressToCell(with: indexPath, dataSource: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.delegate != nil {
            self.delegate?.willDisplayCell(with: tableView, tableViewCell: cell, indexPath: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didEndDisplayCell(with: tableView, tableViewCell: cell, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        let sm: SectionModel = self.sectionModels[indexPath.section]
        let cm: GenericCellModel = sm.cellModels[indexPath.row]
        return cm.isCanFocus
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate != nil {
            self.delegate?.scrollViewDidScroll(scrollView)
        }
    }
}
