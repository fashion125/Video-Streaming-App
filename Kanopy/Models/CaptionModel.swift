//
//  CaptionModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/20/17.
//
//

import UIKit

class CaptionModel: NSObject {

    private(set) var hashCaption: String = ""
    private(set) var created: Int = 0
    private(set) var changed: Int = 0
    private(set) var language: String = ""
    private(set) var url_webvtt: String = ""
    private(set) var url_dfxp: String = ""
    private(set) var url_activetranscript: String = ""
    
    // MARK: - Init methods 
    
    
    init(hashCaption: String, created: Int, changed: Int, url_webvtt: String!, url_dfxp: String!, url_activetranscript: String!, language: String!) {
        
        super.init()
        
        self.hashCaption = hashCaption
        self.created = created
        self.changed = changed
        self.url_webvtt = url_webvtt
        self.url_dfxp = url_dfxp
        self.url_activetranscript = url_activetranscript
        self.language = language
    }
}
