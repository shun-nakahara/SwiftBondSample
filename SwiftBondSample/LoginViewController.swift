//
//  LoginViewController.swift
//  SwiftBondSample
//
//  Created by NakaharaShun on 10/30/15.
//  Copyright © 2015 NakaharaShun. All rights reserved.
//

import UIKit
import Bond
import Appsee

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var countUpButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    let loginModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        Appsee.startScreen("Login Screen")
        Appsee.markViewAsSensitive(self.view)
        
        loginModel.userName.bidirectionalBindTo(userNameTextField.bnd_text)
        loginModel.password.bidirectionalBindTo(passwordTextField.bnd_text)
        
        loginModel.activityIndicatorVisible.bindTo(activityIndicator.bnd_animating)
        
        loginModel.loginButtonEnable.bindTo(loginButton.bnd_enabled)
        
        loginModel.loginStatus.observeNew {(loginStatus: LoginState) in
            switch loginStatus {
            case .InProgress:
                print("in progress")
                break
            case .LoggedIn:
                print("logginf in")
                self.performSegueWithIdentifier("nextPage", sender: self)
                break
            case .None:
                print("none")
                break
            }
        }

        loginButton.bnd_controlEvent.filter { (controlEvents: UIControlEvents) -> Bool in
            return controlEvents == UIControlEvents.TouchUpInside
            }.observeNew { (controlEvents: UIControlEvents) -> () in
                self.loginModel.login()
        }
        

        loginModel.countString.bindTo(self.countLabel.bnd_text)
        let includeEvent: UIControlEvents -> Bool = { (controlEvents: UIControlEvents) -> Bool in
            return controlEvents == UIControlEvents.TouchUpInside
        }
        
        let observer: UIControlEvents -> () = { (controlEvents: UIControlEvents) -> () in
            self.loginModel.countUp()
        }
        countUpButton.bnd_controlEvent.filter(includeEvent).observeNew(observer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        Appsee.unmarkViewAsSensitive(self.view)
    }
    
}

