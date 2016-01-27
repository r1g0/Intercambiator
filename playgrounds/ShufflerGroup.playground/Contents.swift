import UIKit

class Participant {
    let name:String
    let contact:String
    init(name:String,contact:String){
        self.name = name
        self.contact = contact
    }
}

extension Participant: CustomStringConvertible {
    var description : String {return name}
}

extension Participant : Equatable { }
func ==(lhs : Participant, rhs : Participant) -> Bool {
    return lhs.name == rhs.name && lhs.contact == rhs.contact
}

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

class Assignation {
    let giver: Participant
    let receiver: Participant
    init(giver:Participant,receiver:Participant){
        self.giver = giver
        self.receiver = receiver
    }
}

extension Assignation: CustomStringConvertible{
    var description:String {return "\(giver.name) 👉 \(receiver.name)"}
}

class SecretSanta {
    
    private var remainingGroups : [Group]
    private var _assignations : [Assignation]?
    
    init(groups : [Group]) {
        // Make a copy of the group list:
        self.remainingGroups = groups.map { Group(name: $0.name, participants: $0.participants) }
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
}

let g1 = Group(name:"🍎", participants:[
    Participant(name: "🍎1", contact: "n🍎1"),
    Participant(name: "🍎2", contact: "n🍎2"),
    Participant(name: "🍎3", contact: "n🍎3"),
    Participant(name: "🍎4", contact: "n🍎4"),
    Participant(name: "🍎5", contact: "n🍎5")])

let g2 = Group(name:"🍊",participants:[
    Participant(name: "🍊1", contact: "n🍊1")])


let g3 = Group(name:"🍒", participants:[
    Participant(name: "🍒1", contact: "n🍒1"),
    Participant(name: "🍒2", contact: "n🍒2")])

let ss = SecretSanta(groups: [g1,g2,g3])

print("pairs(\(ss.assignations))  done \(ss.assignations.count)")
