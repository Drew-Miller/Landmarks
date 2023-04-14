//
//  ContentView.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var folderManager = FolderManager()
    @State var visibility: NavigationSplitViewVisibility = .automatic
    @State var folderId: UUID?
    @State var noteId: UUID?
    
    var folder: Folder? {
        if let id = folderId {
            return folderManager.folder(id: id)
        }
        return nil
    }
    
    var notes: [Note] {
        if let id = folderId, let folder = folderManager.folder(id: id) {
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
            // Folder Selection View
            List(selection: $folderId) {
                Section {
                    NavigationLink(value: UUID(), label: {
                        Label("All Notes", systemImage: "folder")
                    })
                    
                    ForEach(folderManager.folders, id: \.self) { folder in
                        NavigationLink(value: folder.id, label: {
                            Label(folder.title, systemImage: "folder")
                        })
                    }
                } header: {
                    Text("iCloud")
                }
                
                Spacer()
                
                Button {
                    folderManager.addFolder(title: "New Folder")
                } label: {
                    Label("New Folder", systemImage: "plus")
                }
            }
            .navigationTitle("Folders")
        } content: {
            // Notes Selection View
            ZStack {
                if notes.isEmpty {
                    Text("No Notes")
                }
                
                List(selection: $noteId) {
                    Section {
                        ForEach(notes, id: \.self) { note in
                            NavigationLink(value: note.id, label: {
                                VStack {
                                    Text(note.title)
                                }
                            })
                        }
                    } header: {
                        Text("Notes")
                    }
                } 
                .navigationTitle(folder != nil ? folder!.title : "All Notes")
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
