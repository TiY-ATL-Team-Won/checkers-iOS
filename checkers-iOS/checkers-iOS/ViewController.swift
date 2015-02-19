//
//  ViewController.swift
//  checkers-iOS
//
//  Created by Bobby Towers on 2/17/15.
//  Copyright (c) 2015 Bobby Towers. All rights reserved.
//

import UIKit

@IBDesignable

class ViewController: UIViewController {

    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        
    goToApp()
        
    }
    @IBAction func createAccount(sender: AnyObject) {
    
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    func goToApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("MainMenu") as UIViewController
    
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

