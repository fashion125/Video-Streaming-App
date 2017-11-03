//
//  SettingsService.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/27/17.
//
//

import UIKit

class SettingsService: NSObject {

    /// Instance
    static let sharedInstance = SettingsService()
    static let isFirstStartKey = "isFirstStart"
    
    private(set) var videoQualityModels: Array<VideoQualityModel>!
    
    
    // MARK: - Init method 
    
    
    override init() {
        
        super.init()
        
        self.videoQualityModels = self.generateVideoQualityModels()
    }
    
    
    open func isFirstStartApp() -> Bool {
        return UserDefaults.standard.bool(forKey: SettingsService.isFirstStartKey)
    }
    
    
    open func firstStartIsCompleted() {
        UserDefaults.standard.set(true, forKey: SettingsService.isFirstStartKey)
    }
    
    
    /** This method for tests */
    open func firstStartIsNotCompleted() {
        UserDefaults.standard.set(false, forKey: SettingsService.isFirstStartKey)
    }
    
    
    // MARK: - Tools
    
    
    // MARK: - Cellular Data Usage
    
    
    func updateCellularDataUsage(_ value: Bool!) {
        UserDefaults.standard.set(value, forKey: SettingsValueKeys.cellularDataUsage)
    }
    
    
    func cellularDataUsage() -> Bool {
        
        let value = UserDefaults.standard.bool(forKey: SettingsValueKeys.cellularDataUsage)
        
        return value
    }
    
    
    // MARK: - Video Quality
    
    
    func updateVideoQuality(_ value: String!) {
        UserDefaults.standard.set(value, forKey: SettingsValueKeys.videoQuality)
    }
    
    
    func videoQuality() -> String {
        
        let value = UserDefaults.standard.value(forKey: SettingsValueKeys.videoQuality)
        
        if value == nil {
            return "auto"
        }
        
        return value as! String
    }
    
    
    func titleVideoQuality() -> String {
        
        for item  in self.videoQualityModels {
            if item.keyValue == self.videoQuality() {
                return item.title
            }
        }
        
        return ""
    }
    
    
    // MARK: - Closed Caption 
    
    
    func updateClosedCaptions(_ value: Bool!) {
        UserDefaults.standard.set(value, forKey: SettingsValueKeys.closedCaptions)
    }
    
    
    func closedCaptions() -> Bool {
        
        let value = UserDefaults.standard.bool(forKey: SettingsValueKeys.closedCaptions)
        
        return value
    }
    
    
    // MARK: - Data
    
    
    private func generateVideoQualityModels() -> [VideoQualityModel] {
        
        let autoModel = VideoQualityModel.init(titleValue: "AUTO".localized,
                                               descriptionTextValue: "AUTO_DESCRIPTION".localized,
                                               keyValue: "auto")
        let basicdModel = VideoQualityModel.init(titleValue: "BASIC".localized,
                                                 descriptionTextValue: "BASIC_DESCRIPTION".localized,
                                                 keyValue: "basic")
        
        return [autoModel, basicdModel]
    }
}
