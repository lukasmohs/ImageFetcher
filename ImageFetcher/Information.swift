//
//  Information.swift
//  ImageFetcher
//
//  Created by Lukas Mohs on 18.09.17.
//  Copyright © 2017 Lukas Mohs. All rights reserved.
//

import Foundation

class Information: NSObject, NSCoding {
    var title: String
    var details: String
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.title, forKey: "title")
        encoder.encode(self.details, forKey: "details")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObject(forKey: "title") as? String,
            let details = decoder.decodeObject(forKey: "details") as? String
            else { return nil }
        self.init( title: title, details: details)
    }
    
    init(title:String, details:String){
        self.title = title
        self.details = details
    }
}

