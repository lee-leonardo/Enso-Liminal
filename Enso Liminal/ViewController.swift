//
//  ViewController.swift
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    //MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let login = TWTRLogInButton { (session, error) -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
        }
        
        login.center = self.view.center
        self.view.addSubview(login)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

