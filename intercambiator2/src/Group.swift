//
//  Group.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 12/19/15.
//  Copyright © 2015 Rigo Pinto. All rights reserved.
//

import Foundation


class Group {
    static var counter = 0
    var participants:[Participant]=[]
    var name:String
    init( name:String, participants:[Participant]){
        self.participants=participants
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
}

extension Group : Equatable { }
func ==(lhs : Group, rhs : Group) -> Bool {
    return lhs === rhs
}

extension Group: CustomStringConvertible {
    var description:String {return name}
}