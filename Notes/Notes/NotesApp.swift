//
//  NotesApp.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

@main
struct NotesApp: App {
#if os (macOS)    
    struct FrameSize: Codable {
        var minWidth: Int
        var minHeight: Int
    }
    
    @AppStorage("frameSize") private var frameSizeData: Data?
    
    private var frameSize: FrameSize? {
        get {
            if let data = frameSizeData,
               let frameSize = try? JSONDecoder().decode(FrameSize.self, from: data) {
                return frameSize
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                frameSizeData = encoded
            }
        }
    }
#endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
#if os(macOS)
                .frame(minWidth: frameSizeData ? frameSizeData.minWidth : 800, minHeight: frameSizeData ? frameSizeData.maxWidth : 600)
#endif
        }
    }
}
