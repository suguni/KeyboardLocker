//
//  PreferencesView.swift
//  WorldTime
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Cocoa

class PreferencesView: NSView, LoadableView {

    // MARK: - IBOutlet Properties
    @IBOutlet var appBundleID: NSTextField!
    @IBOutlet var inputSource: NSTextField!
    
    
    // MARK: - Init
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        if load(fromNIBNamed: "PreferencesView") {
            populateFields()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Custom Fileprivate Methods
    fileprivate func populateFields() {
        if let preferredAppBundleID = UserDefaults.standard.string(forKey: "appBundleID") {
            appBundleID.stringValue = preferredAppBundleID
        } else {
            appBundleID.stringValue = "org.gnu.Emacs"
        }
        
        if let preferredInputSource = UserDefaults.standard.string(forKey: "inputSource") {
            inputSource.stringValue = preferredInputSource
        } else {
            inputSource.stringValue = "com.apple.keylayout.ABC"
        }
    }
    
    // MARK: - IBAction Methods
        
    @IBAction func applySelection(_ sender: Any) {
        UserDefaults.standard.set(appBundleID.stringValue, forKey: "appBundleID")
        UserDefaults.standard.set(inputSource.stringValue, forKey: "inputSource")
        dismissPreferences(self)
    }
    
    
    @IBAction func dismissPreferences(_ sender: Any) {
        self.window?.performClose(self)
    }
    
}
