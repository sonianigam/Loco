//
//  NoteViewController.swift
//  FinalApp
//
//  Created by sonia on 8/24/15.
//  Copyright (c) 2015 Sonia Nigam. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        
        for aViewController in viewControllers {
            if(aViewController is LocationDisplayViewController){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
        

    }
  
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        
        for aViewController in viewControllers {
            if(aViewController is LocationDisplayViewController){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
        
    }
    
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
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
