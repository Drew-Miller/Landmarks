//
//  FolderListItemView.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import SwiftUI

struct FolderListItemView: View {
    @EnvironmentObject var folderManager: FolderManager
    @Binding var editMode: EditMode
    @State var isPresenting = false
    @State var folderTitle = ""
    let folder: Folder
    
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
        //.moveDisabled(folder.required)
        .onAppear {
            folderTitle = folder.title
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                folderManager.deleteFolder(folder: folder)
            } label: {
                Label("Delete", systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
        }
        .alert(
            "Rename Folder",
            isPresented: $isPresenting
        ) {
            Button(role: .cancel) {
                folderTitle = folder.title
                isPresenting = false
            } label: {
                Label("Cancel", systemImage: "close")
                    .labelStyle(.titleOnly)
            }
            Button {
                folderManager.renameFolder(folder: folder, name: folderTitle)
            } label: {
                Label("Save", systemImage: "square.and.down.arrow'")
                    .labelStyle(.titleOnly)
            }
            // Any view other than Button would be ignored
            TextField("Rename Folder", text: $folderTitle)
        }
    }
}

#if DEBUG
struct FolderListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif

