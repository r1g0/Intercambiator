//
//  Group.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 12/19/15.
//  Copyright © 2015 Rigo Pinto. All rights reserved.
//

import Foundation


class Group : NSCoder {
    var participants:[Participant]=[]
    var name:String
    
    init( name:String, participants:[Participant]){
        self.participants=participants
        self.name = name
    }
    
    init( name:String){
        self.name = name
    }
    
    var size: Int {return self.participants.count}
    
    func randomParticipant()->Participant{
        precondition(participants.count > 0, "participants array is empty")
        return participants[Int(arc4random_uniform(UInt32(participants.count)))]
    }
    
    func removeParticipant(p:Participant)->Bool{
        let originalIndex = participants.count
        participants = participants.filter() { $0.name != p.name }
        return originalIndex != participants.count
    }
    
    func addParticipant(p:Participant){
        self.participants.append(p);
        self.participants = self.participants.sort { $0.name < $1.name }
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObjectForKey("name") as? String,
            let participants = decoder.decodeObjectForKey("participants") as? [Participant]
            else { return nil }
        
        self.init(
            name: name,
            participants: participants
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.participants, forKey: "participants")
    }
    
    override var description:String {return name}
}

func == (lhs : Group, rhs : Group) -> Bool {
    return lhs === rhs
}