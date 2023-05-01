//
//  ContentView.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var folderManager = FolderManager()
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn
    @State var folder: Folder? = nil
    @State var note: Note? = nil
    @State var search = ""
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            FolderListView(folder: $folder, note: $note)
                .environmentObject(folderManager)
        } content: {
            // Notes Selection View
            ZStack {
                NoteListView(folder: $folder, note: $note)
                    .environmentObject(folderManager)
            }
        } detail: {
            // Note View
            ZStack {
                NoteView(note: $note)
            }
        }
        .searchable(text: $search)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif
