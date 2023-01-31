//
//  calendarApp.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import SwiftUI

@main
struct calendarApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = ContactsListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
    
}
