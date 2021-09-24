//
//  statusMenuController.swift
//  Show me the IP
//
//  Created by Pinky Lam on 8/5/2018.
//  Copyright © 2018 Pinky Lam. All rights reserved.
//

import Cocoa
import os

class statusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu! // Main Menu
    @IBOutlet weak var displaySettingMenu: NSMenu! // Display Format
    @IBOutlet weak var appInfoMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let defaults = UserDefaults.standard
    let displayPreference = "displayPreference"
    
    let bundleShortVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String
    
    let reachability = try! Reachability()
    
    let IpAddr = IpAddress();
    
    let maxSetMenuTitleRetry = 3;
    var setMenuTitleRetryCount = 0;
    
    override func awakeFromNib() {
        os_log("awakeFromNib", log: .default, type: .default)
        
        // Listen to network change
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            os_log("Could not start reachability notifier", log: .default, type: .error)
        }
        
        // Set active submenu item
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        
        if (addrPref != nil) {
            let itemIndex = addrPref as? Int;
            displaySettingMenu.items[itemIndex!].state = NSControl.StateValue.on
        } else {
            displaySettingMenu.items[0].state = NSControl.StateValue.on
        }
        
        appInfoMenuItem.title = "Show me the IP (v" + bundleShortVersionString! + ")"
        
        statusItem.menu = statusMenu
    }
    
    @objc func reachabilityChanged(note: Notification) {
        os_log("Detected change in reachability", log: .default, type: .default)
        
        /* let networkConnection = note.object as! Reachability
        switch networkConnection.connection {
            case .wifi:
                os_log("Reachable via WiFi", log: .default, type: .default)
            case .cellular:
                os_log("Reachable via Cellular", log: .default, type: .default)
            case .none:
                os_log("Network not reachable", log: .default, type: .default)
        } */
        
        setMenuTitle();
    }
    
    @IBAction func quitApp(_ sender: NSMenuItem) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func copyIPAddress(_ sender: NSMenuItem) {
        os_log("Copying IP Address", log: .default, type: .default)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(IpAddr.getFormattedIP(n: 0), forType: NSPasteboard.PasteboardType.string)    }
    
    // Display Formats
    func displaySet(dPref: Int, current: NSMenuItem) {
        os_log("Changing display preference: %{public}s", log: .default, type: .default, String(dPref))
        statusItem.title = IpAddr.getFormattedIP(n:dPref)
        
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        
        // Unset active submenu item
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
        let ipString = IpAddr.getFormattedIP(n: addrPref as? Int);
        statusItem.title = ipString
        os_log("Set menu title: %{public}s", log: .default, type: .default, IpAddr.getFormattedIP(n: addrPref as? Int))
        
        if (!IpAddr.isIPv4(ipAddr: ipString)) {
            if(setMenuTitleRetryCount < maxSetMenuTitleRetry) {
                // Delay set menu title to wait for a IPv4 IP for N seconds
                // Since in some scenario
                setMenuTitleRetryCount += 1
                
                os_log("The current IP is not IPv4 format, retry after 3 seconds.", log: .default, type: .error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    print("Retrying...")
                    self.setMenuTitle()
                }
            } else {
                os_log("Failed to get IP in IPv4 format. Maximum retry hitted, resetting counter.", log: .default, type: .error)
                
                setMenuTitleRetryCount = 0;
            }
        }
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
    
    // For debug use
    @IBAction func refreshIP(_ sender: NSMenuItem) {
        os_log("Manual trigger of refresh IP.", log: .default, type: .default)
        setMenuTitle()
    }
    
    @IBAction func clearUserDefaults(_ sender: NSMenuItem) {
        os_log("Deleting saved preferences.", log: .default, type: .default)
        let addrPref = UserDefaults.standard.object(forKey: displayPreference);
        // Unset active submenu item
        if (addrPref != nil) {
            let itemIndex = addrPref as? Int;
            displaySettingMenu.items[itemIndex!].state = NSControl.StateValue.off
        } else {
            displaySettingMenu.items[0].state = NSControl.StateValue.off
        }
        
        displaySettingMenu.items[0].state = NSControl.StateValue.on
        
        statusItem.title = IpAddr.getFormattedIP(n: 0)
        
        // Delete user pref
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    @IBAction func showAboutMessage(_ sender: NSMenuItem) {
        os_log("Showing About Message.", log: .default, type: .default)
        let alert = NSAlert()
        alert.messageText = "Show me the IP (v" + bundleShortVersionString! + ")"
        alert.informativeText = "Author: Pinky Lam\nDeveloped on 8 May, 2018\n\nThis application is develop to show the current IP address. For internal use only. \n\nKnown issue: \nIP displayed will not refresh sometimes when SSID changes without disconnecting or turning off Wi-Fi."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
