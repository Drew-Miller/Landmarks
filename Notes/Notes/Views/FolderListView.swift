//
//  FolderListView.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import SwiftUI

struct FolderListView: View {
    @StateObject var folderManager = FolderManager()
    @State var editMode = EditMode.inactive
    @Binding var folderId: UUID?
    
    var body: some View {
        // Folder Selection View
        List(selection: $folderId) {
            Section {
                ForEach(folderManager.folders, id: \.self) { folder in
                    NavigationLink(value: folder.id, label: {
                        Label(folder.title, systemImage: "folder")
                        HStack {
                            Spacer()
                            if editMode.isEditing && !folder.required {
                                Button {
                                    
                                } label: {
                                    Label("Options", systemImage: "ellipsis.circle")
                                        .labelStyle(.iconOnly)
                                }
                                
                                Divider()
                            } else if !editMode.isEditing {
                                Text(String(folder.notes.count))
                                    .foregroundColor(.gray)
                                    //.padding(.trailing, 16)
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

#if DEBUG
struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif

