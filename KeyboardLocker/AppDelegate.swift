import Cocoa
import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    
    var isAppTrusted: Bool = false
    
    var appBundleID: String = ""
    var inputSource: String = ""
    
    @IBOutlet weak var menu: NSMenu?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let image = NSImage(named: NSImage.lockLockedTemplateName)
        image?.isTemplate = true
        self.statusItem?.button?.image = image
        if let menu = menu {
            statusItem?.menu = menu
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.appBundleID = UserDefaults.standard.string(forKey: "appBundleID") ?? "org.gnu.Emacs"
        self.inputSource = UserDefaults.standard.string(forKey: "inputSource") ?? "com.apple.keylayout.ABC"
        
        InputSourceManager.initialize()
        
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options = [checkOptPrompt: true]
        isAppTrusted = AXIsProcessTrustedWithOptions(options as CFDictionary?)
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(applicationActivated(_:)),
                                                          name: NSWorkspace.didActivateApplicationNotification,
                                                          object: nil)
        
        UserDefaults.standard.addObserver(self, forKeyPath: "appBundleID",
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
        
        UserDefaults.standard.addObserver(self, forKeyPath: "inputSource",
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    @objc func applicationActivated(_ notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let bundleId = app.bundleIdentifier
        {
            print(bundleId)
            if bundleId == self.appBundleID && self.inputSource != "" {
                changeKeyboard()
            }
        }
    }
    
    func changeKeyboard() {
//        if isAppTrusted {
        let dstSource = InputSourceManager.getInputSource(name: self.inputSource)
            dstSource.select()
            print("changed")
//        } else {
//            print("Not trusted")
//        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            if keyPath == "appBundleID" {
                appBundleID = UserDefaults.standard.string(forKey: keyPath) ?? ""
            } else if keyPath == "inputSource" {
                inputSource = UserDefaults.standard.string(forKey: keyPath) ?? ""
            }
        }
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "preferencesID")) as? ViewController else { return }
        let window = NSWindow(contentViewController: vc)
        window.makeKeyAndOrderFront(nil)
    }
}

