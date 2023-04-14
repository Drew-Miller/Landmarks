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
        var minWidth: CGFloat
        var minHeight: CGFloat
    }
    
    @AppStorage("frameSize") private var frameSizeData: Data?
    
    private var frameSize: FrameSize? {
        get { return JSONData.decode(data: frameSizeData, class: FrameSize.self) }
        set { return JSONData.encode(encode: newValue) { encoded in frameSizeData = encoded} }
    }
#endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(.regularMaterial)
                .accentColor(.yellow)
#if os(macOS)
                .frame(minWidth: frameSize != nil ? frameSize!.minWidth : 800, minHeight: frameSize != nil ? frameSize!.minHeight : 600)
#endif
        }
    }
}
