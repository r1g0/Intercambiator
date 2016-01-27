//
//  Assignment.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 12/23/15.
//  Copyright © 2015 Rigo Pinto. All rights reserved.
//

import Foundation

class Assignation : NSCoder {
    let giver: Participant
    let receiver: Participant
    var notified: Bool = false
    init(giver:Participant,receiver:Participant){
        self.giver = giver
        self.receiver = receiver
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let giver = decoder.decodeObjectForKey("giver") as? Participant,
            let receiver = decoder.decodeObjectForKey("receiver") as? Participant,
            let notified = decoder.decodeObjectForKey("notified") as? Bool
            else { return nil }
        
        self.init(
            giver: giver,
            receiver: receiver
        )
        self.notified = notified
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.giver, forKey: "name")
        coder.encodeObject(self.receiver, forKey: "contact")
        coder.encodeObject(self.notified, forKey: "notified")
    }
    
    override var description:String {return "\(giver.name) 👉 \(receiver.name)"}
}