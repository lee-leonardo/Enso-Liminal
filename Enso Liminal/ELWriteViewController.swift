//
//  ELWriteViewController.swift
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/25/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

import UIKit

class ELWriteViewController: UIViewController, UITextViewDelegate {

    var haikuView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRectMake(self.view.frame.width / 4, self.view.frame.height / 3, self.view.frame.width * 2 / 3, self.view.frame.height * 3 / 4)
        self.haikuView = HaikuTextView(frame: frame)
        self.view.addSubview(haikuView)
    }
    
    
    //MARK: Signal Stuff
    func subscribeSignal() {
        var lettersSig = "A B C D E F G H I".componentsSeparatedByString(" ")
        
        
        rac_signalForSelector("thisIsASelector:").subscribeNext {
            (next) -> Void in
            if let string = next as? String {
                println(string)
            }
        }
//        var signal = lettersSig.rac_textSignal().subscribeNext {
//        (next: AnyObject!) -> () in
//            if let text = next as? String {
//                println(countElements(text))
//            }
//        }
    }
    
    func thisIsASelector(haiku: HaikuTextView) {
        
    }
    
    //MARK: - UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return self.isValidString(text)
    }
    
    //Works currently only for alphanumeric characters and if they are lower case...
    func isValidString(text: String) -> Bool {
        
        //The pattern I desire... but the \[ and \] are troublesome...
        //"[~`@#$%^&*()-_=+\[\]\|{}\\;':\"<>]"
        var pattern = "[~`@#$%^&*()-_=+{}\\;:\"<>]"
        var ifContains = text.rangeOfString(pattern, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil)
        
        if ifContains?.isEmpty != nil {
            return false
        }
        return true
    }
}