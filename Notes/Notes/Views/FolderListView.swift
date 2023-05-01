//
//  FolderListView.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import SwiftUI

struct FolderListView: View {
    @EnvironmentObject var folderManager: FolderManager
    @Binding var folder: Folder?
    @Binding var note: Note?
    @State var editMode = EditMode.inactive
    @State var createNote = false
    @State var search = ""
    
    var body: some View {
        // Folder Selection View
        List(selection: $folder) {
            Section {
                ForEach(folderManager.allFolders, id: \.self) { folder in
                    FolderListItemView(folder: folder, editMode: $editMode)
                        .environmentObject(folderManager)
                }
                .onMove { from, to in
                    folderManager.move(from: from, to: to)
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
                Button {
                    withAnimation {
                        editMode = editMode.isEditing ? .inactive : .active
                    }
                } label: {
                    if editMode.isEditing {
                        Label("Done", systemImage: "check")
                            .labelStyle(.titleOnly)
                            .fontWeight(.bold)
                    } else {
                        Label("Edit", systemImage: "square.and.pencil")
                            .labelStyle(.titleOnly)
                    }
                }
            }
            
            // Bottom Toolbar
            ToolbarItemGroup(placement: .bottomBar) {
                // Create new folder
                Button {
                    folderManager.create(title: "New Folder")
                } label: {
                    Label("New Folder", systemImage: "folder.badge.plus")
                }
                
                Spacer()
                
                // Create new note
                Button {
                    note = folderManager.createNote()
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

