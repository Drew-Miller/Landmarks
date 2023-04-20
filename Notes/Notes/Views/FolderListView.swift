//
//  FolderListView.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import SwiftUI

struct FolderListView: View {
    @EnvironmentObject var folderManager: FolderManager
    @State var editMode = EditMode.inactive
    @Binding var folderId: UUID?
    
    var body: some View {
        // Folder Selection View
        List(selection: $folderId) {
            Section {
                ForEach(folderManager.folders, id: \.self) { folder in
                    FolderListItemView(editMode: $editMode, folder: folder)
                        .environmentObject(folderManager)
                }
                .onMove{ from, to in folderManager.moveFolder(from: from, to: to) }
            } header: {
                Text("My Folders")
            }
        }
        .navigationTitle("Folders")
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
                    folderManager.addFolder(title: "New Folder \(folderManager.folders.count)")
                } label: {
                    Label("New Folder", systemImage: "folder.badge.plus")
                }
                
                Spacer()
            }
        }
    }
}

struct FolderItemView: View {
    @StateObject var folderManager = FolderManager()
    @Binding var editMode: EditMode
    @State var isPresenting = false
    @Binding var folder: Folder
    
    var body: some View {
        NavigationLink(value: folder.id, label: {
            Label(folder.title, systemImage: "folder")
            HStack {
                Spacer()
                if editMode.isEditing && !folder.required {
                    Menu {
                        // Rename
                        Button {
                            isPresenting = true
                        } label: {
                            Label("Rename", systemImage: "pencil")
                        }
                        
                        // Delete
                        Button {
                            folderManager.deleteFolder(folder: folder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                            .labelStyle(.iconOnly)
                    }
                    Divider()
                } else if !editMode.isEditing {
                    Text(String(folder.notes.count))
                        .foregroundColor(.gray)
                }
            }
        })
        .disabled(editMode.isEditing && folder.required)
        .moveDisabled(folder.required)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                folderManager.deleteFolder(folder: folder)
            } label: {
                Label("Delete", systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
        }
        .alert("Rename Folder :2", isPresented: $isPresenting, actions: {
            // Any view other than Button would be ignored
            TextField("Rename Folder :3", text: .constant(folder.title))
        }, message: {
            // Any view other than Text would be ignored
            TextField("Rename Folder", text: .constant(folder.title))
        })
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

