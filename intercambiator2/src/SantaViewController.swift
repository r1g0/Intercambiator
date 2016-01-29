//
//  ViewController.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 12/18/15.
//  Copyright © 2015 Rigo Pinto. All rights reserved.
//

import UIKit
import MessageUI

class SantaViewController: UIViewController, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet weak var pairsTableView: UITableView!
    var pairs:[Assignation] = []
    var savedPairsKey = ""
    var currentSending:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairsTableView.delegate = self
        pairsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let pairs = NSUserDefaults.standardUserDefaults().objectForKey(savedPairsKey) as? NSData {
            self.pairs = NSKeyedUnarchiver.unarchiveObjectWithData(pairs) as! [Assignation]
        }
        if (pairs.count==0){
            doTheShuffle()
        }
        print(pairs)
    }
    
    func doTheShuffle(){
        var gs:[Group] = []
        var g = Group(name:"🦄", participants:[
            Participant(name:"p1",contact:"111-111"),
            Participant(name:"p2",contact:"222-222"),
            Participant(name:"p3",contact:"333-333"),
            Participant(name:"p4",contact:"444-444"),
            Participant(name:"p5",contact:"555-555")])
        gs.append(g)
        g = Group(name:"🐒",participants:[
            Participant(name:"q1",contact:"666-666"),
            Participant(name:"q2",contact:"777-777"),
            Participant(name:"q3",contact:"888-888"),
            Participant(name:"q4",contact:"999-999")])
        gs.append(g)
        g = Group(name:"🐋",participants:[
            Participant(name:"r1",contact:"000-000"),
            Participant(name:"r2",contact:"123-123"),
            Participant(name:"r3",contact:"234-234"),
            Participant(name:"r4",contact:"345-345")])
        gs.append(g)
        self.pairs = SecretSanta(name:"🎅🏽" ,groups: gs).assignations
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.pairs)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: savedPairsKey)
        pairsTableView.reloadData()
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            print("Cancelled")
            break;
        case MessageComposeResultFailed:
            print("fail")
            break;
        case MessageComposeResultSent:
            let p = pairs[self.currentSending]
            p.notified = true
            self.pairs[self.currentSending] = p
            let data = NSKeyedArchiver.archivedDataWithRootObject(self.pairs)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: savedPairsKey)
            break;
        default:
            break;
        }
        self.currentSending = -1
        self.dismissViewControllerAnimated(true, completion: {self.pairsTableView.reloadData()})
    }
}


extension SantaViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = pairsTableView.dequeueReusableCellWithIdentifier("paircell")! as UITableViewCell
        let pair: Assignation = pairs[indexPath.row]
        cell.textLabel?.text = pair.giver.name
        cell.detailTextLabel?.text = pair.giver.contact + (pair.notified ? "🤘🏽":"")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pair = pairs[indexPath.row]
        if(MFMessageComposeViewController.canSendText())
        {
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self;
            messageController.recipients = [pair.giver.contact];
            messageController.body = "SECRET SANTA MESSAGE \(pair.giver.name) 2016: You have to give a present to \(pair.receiver.name).  See you the 5th of November!";
            self.currentSending = indexPath.row;
            
            // Present message view controller on screen
            presentViewController(messageController, animated:true, completion: nil)
        }else{
            print("It cant send text")
        }
    }

}
