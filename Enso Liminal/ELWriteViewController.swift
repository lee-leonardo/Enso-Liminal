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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
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
//    func textViewDidChange(textView: UITextView) {
//        //
//    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var regexp = "`1234567890-=~!@#$%^&*()_+[]\\{}|;':\",./<>?";

        var checkingString = text.rangeOfString(regexp, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil)
        
        //Got to think about this to see if this is a good way to do it... a bit hard to read.
        if checkingString != nil {
            if checkingString!.isEmpty {
                return true
            }
        }
        return checkingString?.isEmpty == nil
    }
}