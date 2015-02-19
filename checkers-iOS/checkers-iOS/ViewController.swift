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

    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func createAccount(sender: AnyObject) {
    
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton = UIButton(frame: CGRectMake(50, 100, 100, 50))
        
        loginButton.backgroundColor = UIColor.greenColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

