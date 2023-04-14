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
                        Spacer()
                        
                        if editMode.isEditing && !folder.required {
                            Image(systemName: "ellipsis.circle")
                            Divider()
                            Image(systemName: "line.3.horizontal")
                        } else if !editMode.isEditing {
                            Text(String(folder.notes.count))
                                .padding(.trailing, 24)
                        }
                    })
                    .disabled(editMode.isEditing && folder.required)
                    .deleteDisabled(!editMode.isEditing || folder.required)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            folderManager.deleteFolder(folder: folder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .labelStyle(.iconOnly)
                        }
                    }
                }
            } header: {
                Text("My Folders")
            }
        }
        .navigationTitle("Folders")
        .background(.regularMaterial)
        .environment(\.editMode, $editMode)
        .moveDisabled(false)
        .deleteDisabled(false)
        .toolbarRole(.navigationStack)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if editMode.isEditing {
                    Button(role: .cancel) {
                        withAnimation {
                            editMode = .inactive
                        }
                    } label: {
                        Label("Done", systemImage: "check")
                            .labelStyle(.titleOnly)
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
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    folderManager.addFolder(title: "New Folder")
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

