//
//  NotesApp.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}
