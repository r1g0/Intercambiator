//
//  ListViewController.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 1/26/16.
//  Copyright © 2016 Rigo Pinto. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    static let SavedSantaKey = "SavedSantaKey";
    
    @IBOutlet weak var tableView: UITableView!
    var santas:[String] = []
    var selectedSanta:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let santas = NSUserDefaults.standardUserDefaults().objectForKey(ListViewController.SavedSantaKey) as? NSData {
            self.santas = NSKeyedUnarchiver.unarchiveObjectWithData(santas) as! [String]
        }
        print(santas)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return santas.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("santacell")! as UITableViewCell
        let santa = santas[indexPath.row]
        cell.textLabel?.text = santa
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("to santa", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to santa" {
            let dv = segue.destinationViewController as! SantaViewController
            dv.savedPairsKey = selectedSanta
        }
    }
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    
}
