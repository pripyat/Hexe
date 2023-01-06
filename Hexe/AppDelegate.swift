//
//  AppDelegate.swift
//  Hexe
//
//  Created by David Schiefer on 02.01.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var applicationPreferences : Preferences = Preferences.init()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @IBAction func showPreferences(_ sender: NSMenuItem)
    {
        // load preferences window
        applicationPreferences.showPreferences()
    }
}

