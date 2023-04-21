//
//  FolderListView.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import SwiftUI

struct FolderListView: View {
    @EnvironmentObject var folderManager: FolderManager
    @Binding var folderId: UUID?
    @Binding var noteId: UUID?
    @State var editMode = EditMode.inactive
    @State var createNote = false
    @State var search = ""
    
    var body: some View {
        // Folder Selection View
        List(selection: $folderId) {
            Section {
                ForEach(folderManager.folders, id: \.self) { folder in
                    FolderListItemView(editMode: $editMode, folder: folder)
                        .environmentObject(folderManager)
                }
                .onMove { from, to in
                    folderManager.moveFolder(from: from, to: to)
                }
            } header: {
                Text("My Folders")
            }
        }
        .navigationTitle("Folders")
        .searchable(text: $search)
        .environment(\.editMode, $editMode)
        .moveDisabled(false)
        .deleteDisabled(true)
        .toolbar {
            // Top Toolbar
            ToolbarItem(placement: .automatic) {
                // Edit Button
                if editMode.isEditing {
                    Button(role: .cancel) {
                        withAnimation {
                            editMode = .inactive
                        }
                    } label: {
                        Label("Done", systemImage: "check")
                            .labelStyle(.titleOnly)
                            .fontWeight(.bold)
                    }
                } else {
                    Button {
                        withAnimation {
                            editMode = .active
                        }
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .labelStyle(.titleOnly)
                    }
                }
            }
            
            // Bottom Toolbar
            ToolbarItemGroup(placement: .bottomBar) {
                // Create new folder
                Button {
                    folderManager.addFolder(title: "New Folder")
                } label: {
                    Label("New Folder", systemImage: "folder.badge.plus")
                }
                
                Spacer()
                
                // Create new note
                Button {
                    let note = Note()
                    folderManager.createNote(note: note)
                    noteId = note.id
                } label: {
                    Label("New Note", systemImage: "square.and.pencil")
                }
            }
        }
    }
}

#if DEBUG
struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif

