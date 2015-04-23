//
//  LoginViewController.swift
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/22/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTwitter()
        self.setupFacebook()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

//MARK: - Twitter
    func setupTwitter() {
        let login = TWTRLogInButton { (session, error) -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
        }
        
        login.center = self.view.center
        self.view.addSubview(login)
    }
    
//MARK: - Facebook
    func setupFacebook() {
        
    }
}
