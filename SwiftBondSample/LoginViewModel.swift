//
//  LoginModel.swift
//  SwiftBondSample
//
//  Created by NakaharaShun on 10/30/15.
//  Copyright © 2015 NakaharaShun. All rights reserved.
//

import Bond

enum LoginState {
    case None
    case InProgress
    case LoggedIn
}

class LoginViewModel {

    let userName: Observable<String?> = Observable<String?>("Steve")
    let password: Observable<String?> = Observable<String?>("")
    
    let loginStatus: Observable<LoginState> = Observable<LoginState>(.None)
    
    
    var count: Int = 0
    let countString: Observable<String?> = Observable<String?>("")

    
    private var loginInProgress: EventProducer<Bool> {
        return loginStatus.map({ (loginState: LoginState) -> Bool in
            return loginState == LoginState.InProgress
        })
    }
    
    internal var activityIndicatorVisible: EventProducer<Bool> {
        return loginInProgress
    }
    
    internal var loginButtonEnable: EventProducer<Bool> {
        let userNameValid: EventProducer<Bool> = userName.map { (userName: String?) -> Bool in
            return userName?.characters.count > 2
        }
        
        let passwordValid: EventProducer<Bool> = password.map { (password: String?) -> Bool in
            return password?.characters.count > 2
        }
        
        return userNameValid.combineLatestWith(passwordValid).combineLatestWith(loginInProgress).map { (inputs: (Bool, Bool), progress: Bool) -> Bool in
            inputs.0 == true && inputs.1 == true && progress == false
        }
    }
    
    func login() {
        self.loginStatus.value = .InProgress

        let delayTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            self.loginStatus.value = .LoggedIn
        })
    }
    
    func countUp() {
        self.count++
        self.countString.value = "\(self.count)"
    }
}