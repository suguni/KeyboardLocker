//
//  ViewController.swift
//  KeyboardLocker
//
//  Created by suguni on 2020/12/30.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        view.window?.styleMask.remove(.resizable)
        view.window?.styleMask.remove(.miniaturizable)
        view.window?.center()

        let preferencesView = PreferencesView(frame: self.view.bounds)
        preferencesView.add(toView: self.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

