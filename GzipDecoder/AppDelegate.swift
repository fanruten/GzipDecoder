//
//  AppDelegate.swift
//  GzipDecoder
//
//  Created by Ruslan Gumennyi on 20/06/14.
//  Copyright (c) 2014 e-legion. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window: NSWindow

    @IBOutlet var inputTextScrollView: NSScrollView

    var outputTextViewString : NSAttributedString?
    
    var inputTextField : NSTextView {
    get {
        return inputTextScrollView.contentView.documentView as NSTextView
    }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    @IBAction func decodeButtonTapped(sender: NSButton) {
        var inputText = self.inputTextField.textStorage.string;
        
        var rawData = NSMutableData()
        
        var lines = inputText.componentsSeparatedByString("\n")
        for line in lines {
            var lineComps = line.componentsSeparatedByString(" ")
            for var i = 1; i < lineComps.count && i < 17; i++ {
                var comp = lineComps[i]
                if comp.utf16count > 0 {
                    var val: CUnsignedInt = 0
                    NSScanner.scannerWithString(comp).scanHexInt(&val)
                    var b: Byte = Byte(val)
                    rawData.appendBytes(&b, length: 1)
                }
            }
        }
        
        var encodedData = rawData.gzipInflate()
        var encodedString = NSString(data: encodedData, encoding: NSUTF8StringEncoding)
        var attrString = NSAttributedString(string: encodedString)
        self.outputTextViewString = attrString
    }
}

