//
//  ELWriteViewController.swift
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/25/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

import UIKit

class ELWriteViewController: UIViewController {

    var haikuView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRectMake(self.view.frame.width / 4, self.view.frame.height / 3, self.view.frame.width * 2 / 3, self.view.frame.height * 3 / 4)
        self.haikuView = UITextView(frame: frame)
        self.view.addSubview(haikuView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    

}
