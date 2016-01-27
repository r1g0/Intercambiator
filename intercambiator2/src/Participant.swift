//
//  Participant.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 12/19/15.
//  Copyright © 2015 Rigo Pinto. All rights reserved.
//

import Foundation

class Participant: NSCoder{
    let name:String
    let contact:String
    init(name:String,contact:String){
        self.name = name
        self.contact = contact
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObjectForKey("name") as? String,
            let contact = decoder.decodeObjectForKey("contact") as? String
            else { return nil }
        
        self.init(
            name: name,
            contact: contact
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.contact, forKey: "contact")
    }
    
    override var description : String {return name}
}

func ==(lhs : Participant, rhs : Participant) -> Bool {
    return lhs.name == rhs.name && lhs.contact == rhs.contact
}