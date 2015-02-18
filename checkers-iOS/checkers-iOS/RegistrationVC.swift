//
//  RegistrationVC.swift
//  checkers-iOS
//
//  Created by Bobby Towers on 2/18/15.
//  Copyright (c) 2015 Bobby Towers. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func createAccountAction(sender: UIButton) {
        
        if let token = User.currentUser().token {
            
            println(token)
            
        } else {
            
            User.currentUser().getUserToken()
            
        }

    }
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
        
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
