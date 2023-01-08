//
//  Preferences.swift
//  Hexe
//
//  Created by David Schiefer on 06.01.2023.
//

import Foundation
import Cocoa

class Preferences : NSObject
{
    @IBOutlet weak var hexePreferencesWindow: NSWindow!
    
    public static let DASettingsKeyAutosave = "DAEnableAutosaving"
    public static let DASettingsKeyShowLineCount = "DAShowLineCount"
    
    private let defaultSettings = [Preferences.DASettingsKeyAutosave : true, Preferences.DASettingsKeyShowLineCount : true]
    
    override init()
    {
        // set the default user settings
        UserDefaults.standard.register(defaults: self.defaultSettings)
    }
    
    func showPreferences()
    {
        Bundle.main.loadNibNamed("Preferences", owner: self, topLevelObjects: nil)
        
        hexePreferencesWindow.center()
        hexePreferencesWindow.makeKeyAndOrderFront(self)
    }
    
    @IBAction func resetPreferences(_ sender: NSButton)
    {
        for settingsKey in defaultSettings.keys
        {
            UserDefaults.standard.removeObject(forKey: settingsKey)
        }
    }
}
