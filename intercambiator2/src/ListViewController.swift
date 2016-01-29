//
//  ListViewController.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 1/26/16.
//  Copyright © 2016 Rigo Pinto. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    static let SavedSantaKey = "SavedSantaKey2";
    
    @IBOutlet weak var santaField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var santas:[SecretSanta] = []
    var selectedSanta:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadSantas()
        print(santas)
    }
    
    func reloadSantas(){
        if let santasData = NSUserDefaults.standardUserDefaults().objectForKey(ListViewController.SavedSantaKey) as? NSData {
            self.santas = NSKeyedUnarchiver.unarchiveObjectWithData(santasData) as! [SecretSanta]
        }
        tableView.reloadData()
    }
    
    @IBAction func createList(sender: UIButton) {
        if let newSantaName = santaField.text {
            if newSantaName != "" {
                let defaults = NSUserDefaults.standardUserDefaults()
                self.santas.append(SecretSanta(name: newSantaName));
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.santas)
                defaults.setObject(data, forKey: newSantaName)
                defaults.synchronize()
                reloadSantas()
            }else{
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(CGPoint: CGPointMake(santaField.center.x - 10, santaField.center.y))
                animation.toValue = NSValue(CGPoint: CGPointMake(santaField.center.x + 10, santaField.center.y))
                santaField.layer.addAnimation(animation, forKey: "position")
            }
        }
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return santas.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("santa cell")! as UITableViewCell
        let santa = santas[indexPath.row]
        cell.textLabel?.text = santa.name
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