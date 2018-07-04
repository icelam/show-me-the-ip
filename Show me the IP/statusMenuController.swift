//
//  statusMenuController.swift
//  Show me the IP
//
//  Created by Pinky Lam on 8/5/2018.
//  Copyright © 2018 Pinky Lam. All rights reserved.
//

import Cocoa

class statusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu! //Main Menu
    @IBOutlet weak var displaySettingMenu: NSMenu! // Display Format
    @IBOutlet weak var appInfoMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let defaults = UserDefaults.standard
    let displayPreference = "displayPreference"
    
    let bundleShortVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String
    
    let reachability = Reachability()!
    
    override func awakeFromNib() {
        print("awakeFromNib")
        
        //Listen to network change
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Could not start reachability notifier")
        }
        
        //set active submenu item
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        
        if (addrPref != nil) {
            let itemIndex = addrPref as? Int;
            displaySettingMenu.items[itemIndex!].state = NSControl.StateValue.on
        } else {
            displaySettingMenu.items[0].state = NSControl.StateValue.on
        }
        
        //statusItem.title = getIpAddress().getFormattedIP(n: addrPref as? Int)
        
        appInfoMenuItem.title = "Show me the IP (v" + bundleShortVersionString! + ")"
        
        statusItem.menu = statusMenu
    }
    
    @objc func reachabilityChanged(note: Notification) {
        print("Reachability changed")
        
        /*let networkConnection = note.object as! Reachability
        switch networkConnection.connection {
            case .wifi:
                print("Reachable via WiFi")
            case .cellular:
                print("Reachable via Cellular")
            case .none:
                print("Network not reachable")
        }*/
        
        setMenuTitle()
    }
    
    @IBAction func quitApp(_ sender: NSMenuItem) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func copyIPAddress(_ sender: NSMenuItem) {
        print("Copy IP Address")
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(getIpAddress().getFormattedIP(n: 0)!, forType: NSPasteboard.PasteboardType.string)    }
    
    //Display Formats
    func displaySet(dPref: Int, current: NSMenuItem) {
        print("Change display preference")
        statusItem.title = getIpAddress().getFormattedIP(n:dPref)
        
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        
        //unset active submenu item
        if (addrPref != nil) {
            let itemIndex = addrPref as? Int;
            displaySettingMenu.items[itemIndex!].state = NSControl.StateValue.off
        } else {
            displaySettingMenu.items[0].state = NSControl.StateValue.off
        }
        
        current.state = NSControl.StateValue.on
        
        defaults.setValue(dPref, forKey: displayPreference)
    }
    
    func setMenuTitle() {
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        statusItem.title = getIpAddress().getFormattedIP(n: addrPref as? Int)
        print("Set menu title: " + getIpAddress().getFormattedIP(n: addrPref as? Int)!)
    }
    
    @IBAction func displayFullIP(_ sender: NSMenuItem) {
        displaySet(dPref: 0, current: sender)
    }
    
    @IBAction func displayIPWithoutNetworkPrefix(_ sender: NSMenuItem) {
        displaySet(dPref: 1, current: sender)
    }
    
    @IBAction func displayHalfIP(_ sender: NSMenuItem) {
        displaySet(dPref: 2, current: sender)
    }
    
    @IBAction func displayHostSuffixOfIP(_ sender: NSMenuItem) {
        displaySet(dPref: 3, current: sender)
    }
    
    //Debug
    @IBAction func refreshIP(_ sender: NSMenuItem) {
        print("Refresh IP")
        setMenuTitle();
    }
    
    @IBAction func clearUserDefaults(_ sender: NSMenuItem) {
        print("Delete saved preferences")
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        //unset active submenu item
        if (addrPref != nil) {
            let itemIndex = addrPref as? Int;
            displaySettingMenu.items[itemIndex!].state = NSControl.StateValue.off
        } else {
            displaySettingMenu.items[0].state = NSControl.StateValue.off
        }
        
        displaySettingMenu.items[0].state = NSControl.StateValue.on
        
        statusItem.title = getIpAddress().getFormattedIP(n: 0)
        
        //delete user pref
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    @IBAction func showAboutMessage(_ sender: NSMenuItem) {
        print("Show About Message")
        let alert = NSAlert()
        alert.messageText = "Show me the IP (v" + bundleShortVersionString! + ")"
        alert.informativeText = "Author: Pinky Lam\nDeveloped on 8 May, 2018\n\nThis application is develop to show the current IP address. For internal use only. \n\nKnown issue: \nIP displayed will not refresh sometimes when SSID changes without disconnecting or turning off Wi-Fi."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
