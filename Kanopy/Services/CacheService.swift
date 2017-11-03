//
//  CacheService.swift
//  Kanopy
//
//  Created by Boris Esanu on 15.05.17.
//
//

import UIKit

class CacheService: NSObject {

    /// Instance
    static let sharedInstance = CacheService()
    
    
    /** Method return file path in document directory with file name
     - parameter fileName: Name for file
     */
    func filePath(_ fileName: String!) -> String {
        
        let destinationFolder =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
        let sketchPath = destinationFolder?.appending(fileName)
        
        return sketchPath!
    }
    
    
    func saveDataToFile(_ data: NSData!, key: String!) {
        
        do {
            try data.write(toFile: self.filePath("/" + key + AuthService.sharedInstance.userID + AuthService.sharedInstance.currentIdentity + ".json"), options: .atomic)
        } catch {
            print(error)
        }
    }
    
    
    func dataFromFile(_ key: String!) -> NSData? {

        let data = NSData(contentsOfFile: self.filePath("/" + key + AuthService.sharedInstance.userID  + AuthService.sharedInstance.currentIdentity + ".json"))
        
        return data
    }
}
