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
    var id: Int32
    var date: Date
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.title, forKey: "title")
        encoder.encode(self.details, forKey: "details")
        encoder.encode(self.id, forKey: "id")
        encoder.encode(self.date, forKey:"date")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let id = decoder.decodeInt32(forKey: "id")
        guard let title = decoder.decodeObject(forKey: "title") as? String,
            let details = decoder.decodeObject(forKey: "details") as? String,
            let date = decoder.decodeObject(forKey: "date") as? Date
            else { return nil }
        self.init( title: title, details: details, id: id, date: date)
    }
    
    init(title:String, details:String, id:Int32, date:Date){
        self.title = title
        self.details = details
        self.id = id
        self.date = date
    }
}

