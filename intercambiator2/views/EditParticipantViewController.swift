//
//  EditParticipantViewController.swift
//  intercambiator2
//
//  Created by Rigo Pinto on 2/9/16.
//  Copyright © 2016 Rigo Pinto. All rights reserved.
//

import UIKit

class EditParticipantViewController: UIViewController {

    override func loadView() {
        
        self.title = "Editar"
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonItemClicked:"), animated: true)
    }

    func barButtonItemClicked(){
        print("hola mundo")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
