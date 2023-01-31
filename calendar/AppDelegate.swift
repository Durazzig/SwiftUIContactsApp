//
//  AppDelegate.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import Foundation
import SwiftUI
import Contacts

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
          print("Access to contacts granted: \(access)")
        }
        
        return true
    }
}
