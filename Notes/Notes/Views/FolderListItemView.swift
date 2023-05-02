//
//  FolderListItemView.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import SwiftUI

struct FolderListItemView: View {
    @EnvironmentObject var folderManager: FolderManager
    @Binding var folder: Folder
    @Binding var editMode: EditMode
    @State var isPresenting = false
    @State var rename = ""
    
    var body: some View {
        NavigationLink(value: folder, label: {
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
                            folderManager.delete(folder)
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
            if !folder.required {
                Button(role: .destructive) {
                    folderManager.delete(folder)
                } label: {
                    Label("Delete", systemImage: "trash")
                        .labelStyle(.iconOnly)
                }
            }
        }
        .onAppear {
            rename = folder.title
        }
        .alert(
            "Rename Folder",
            isPresented: $isPresenting
        ) {
            Button(role: .cancel) {
                rename = folder.title
                isPresenting = false
            } label: {
                Label("Cancel", systemImage: "close")
                    .labelStyle(.titleOnly)
            }
            Button {
                folderManager.rename(folder, name: rename)
            } label: {
                Label("Save", systemImage: "square.and.down.arrow'")
                    .labelStyle(.titleOnly)
            }
            // Any view other than Button would be ignored
            TextField("Rename Folder", text: $rename)
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

