//
//  FileService.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/27/17.
//
//

import UIKit

class FileService: NSObject {

    /// Instance
    static let sharedInstance = FileService()
    
    
    // MARK: - Open tools 
    
    
    /** Method save record for item
     - parameter fileName: Name for file
     - parameter value: Value for saving
     - parameter itemID: Item identifire for saving
     */
    open func saveRecord(_ fileName: String!, _ value: Any, itemID: String!)
    {
        
        let str: Dictionary = [itemID: value]
        var allRecords = self.getAllRecorders(fileName)
        
        let record = self.getRecord(fileName, itemID: itemID)
        
        if record != nil {
            allRecords.remove(at: self.indexForElement(fileName, itemID)!)
        }
        
        allRecords.append(str)
        
        if let array: NSArray = allRecords as NSArray? {
            array.write(toFile: self.filePath(fileName), atomically: true)
        }
    }
    
    
    /** Method return record for item
     - parameter fileName: Name for file
     - itemID: Item identifire
     */
    func getRecord(_ fileName: String!, itemID: String) -> Dictionary<String, Any>? {
        let allRecords = self.getAllRecorders(fileName)
        
        for record in allRecords {
            if record[itemID] != nil {
                return record
            }
        }
        
        return nil
    }
    
    
    /** Method return element's index for item
     - parameter fileName: Name for file
     - itemID: Item identifire
     */
    func indexForElement(_ fileName: String!, _ itemID: String) -> Int? {
        let allRecords = self.getAllRecorders(fileName)
        
        for (index, element) in allRecords.enumerated() {
            if element[itemID] != nil {
                return index
            }
        }
        
        return nil
    }
    
    
    /** Method return all records in files 
     - parameter fileName: Name for file
     */
    func getAllRecorders(_ fileName: String!) -> Array<Dictionary<String, Any>> {
        let array = NSArray(contentsOfFile: self.filePath(fileName))
        
        if array == nil {
            let newArray: Array<Dictionary<String, Any>> = Array<Dictionary<String, Any>>()
            return newArray
        }
        return array as! Array<Dictionary<String, Any>>
    }
    
    
    /** Method return file path in document directory with file name
     - parameter fileName: Name for file
     */
    func filePath(_ fileName: String!) -> String {
        
        let destinationFolder =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
        let sketchPath = destinationFolder?.appending(fileName)
        
        return sketchPath!
    }
}

