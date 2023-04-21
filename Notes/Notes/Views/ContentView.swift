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
    @State var search = ""

    @State var folderId: UUID?
    @State var noteId: UUID?
    
    var folder: Folder? {
        if let id = folderId {
            return folderManager.folder(id: id)
        }
        return nil
    }
    
    var notes: [Note] {
        if let folder = folder {
            return folder.notes
        }
        return folderManager.allNotes
    }
    
    var note: Note? {
        if let folder = folder, let id = noteId {
            return folder.note(id)
        }
        
        return !folderManager.allNotes.isEmpty ? folderManager.allNotes[0] : nil
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            FolderListView(folderId: $folderId, noteId: $noteId)
                .environmentObject(folderManager)
        } content: {
            // Notes Selection View
            ZStack {
                if notes.isEmpty {
                    Text("No Notes")
                }
                
                if let folder = folder {
                    NoteListView(folder: .constant(folder), noteId: $noteId)
                        .environmentObject(folderManager)
                }
                
            }
        } detail: {
            // Note View
            ZStack {
                if let note = note {
                    NoteView(note: .constant(note))
                } else {
                    Text("Hello, world!")
                }
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
