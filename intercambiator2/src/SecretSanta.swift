//
//  SecretSanta.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 12/23/15.
//  Copyright © 2015 Rigo Pinto. All rights reserved.
//

import Foundation

class SecretSanta : NSCoder{
    
    var name : String
    private var remainingGroups : [Group]
    private var _assignations : [Assignation]?
    
    init(name: String, groups : [Group]) {
        // Make a copy of the group list:
        self.name = name
        self.remainingGroups = groups.map { Group(name: $0.name, participants: $0.participants) }
    }
    
    init(name: String) {
        // Make a copy of the group list:
        self.name = name
        self.remainingGroups = []
    }
    
    func addGroup(g:Group){
        self.remainingGroups.append(g)
    }
    
    func sortGroups() {
        // Remove groups without participants:
        remainingGroups = remainingGroups.filter { $0.size > 0 }
        // Sort by number of participants in decreasing order:
        remainingGroups.sortInPlace { $1.size < $0.size }
    }
    
    func randomGroup(includeLargest:Bool = true)->Group{
        let offset:Int = includeLargest ? 0 : 1
        precondition(remainingGroups.count > offset, includeLargest ? "groups array is empty":"not enoughgroups in array")
        return remainingGroups[offset + Int(arc4random_uniform(UInt32(remainingGroups.count - offset)))]
    }
    
    var assignations : [Assignation]  {
        if _assignations == nil {
            _assignations = assignPairs()
        }
        return _assignations!
    }
    
    private func assignPairs() -> [Assignation] {
        var shuffledParticipants : [Assignation] = []
        sortGroups()
        var giverGroup = randomGroup()
        var giver = giverGroup.randomParticipant()
        let firstGiver = giver
        
        while true {
            giverGroup.removeParticipant(giver)
            
            guard let groupIndex = remainingGroups.indexOf(giverGroup) else {
                fatalError("group not found")
            }
            
            // Determine destination group:
            var receiverGroup : Group
            if groupIndex > 0 {
                // giver is not from the largest group(0)
                receiverGroup = remainingGroups[0]
            } else if remainingGroups.count > 1 {
                // giver is from the largest group(0), there is at least one other group
                receiverGroup = randomGroup(false)
            } else if remainingGroups[0].size > 0 {
                // There is only one group, but at least one receiver left
                receiverGroup = remainingGroups[0]
            } else {
                // This was the last giver
                shuffledParticipants.append(Assignation(giver: giver, receiver: firstGiver))
                break
            }
            
            // Determine receiver in destination group and assign:
            let receiver = receiverGroup.randomParticipant()
            shuffledParticipants.append(Assignation(giver: giver, receiver: receiver))
            // Prepare for next round:
            sortGroups()
            giverGroup = receiverGroup
            giver = receiver
        }
        

        return shuffledParticipants
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObjectForKey("name") as? String,
            let remainingGroups = decoder.decodeObjectForKey("remainingGroups") as? [Group],
            let assignations = decoder.decodeObjectForKey("assignations") as? [Assignation]
            else { return nil }
        
        self.init(
            name: name,
            groups: remainingGroups
        )
        _assignations = assignations
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.remainingGroups, forKey: "remainingGroups")
        coder.encodeObject(_assignations, forKey: "assignations")
    }
}