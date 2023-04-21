//
//  NoteListView.swift
//  Notes
//
//  Created by Drew Miller on 4/19/23.
//

import SwiftUI

struct NoteListView: View {
    @EnvironmentObject var folderManager: FolderManager
    @Binding var folder: Folder
    @Binding var noteId: UUID?
    @State var search = ""
    @State var createNote = false
    
    var body: some View {
        NavigationStack {
            List(selection: $noteId) {
                ForEach(folder.notes, id: \.self) { note in
                    NoteListItemView(note: note, folderTitle: folder.title)
                        .environmentObject(folderManager)
                }
            }
        }
#if os(iOS)
        .navigationTitle(folder.title)
#endif
        .listStyle(.sidebar)
        .searchable(text: $search)
        .moveDisabled(false)
        .deleteDisabled(false)
        .toolbar {
            // Top Toolbar
            ToolbarItem(placement: .automatic) {
                // Options menu
                Menu {
                    Button {
                        print("hello")
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                        .labelStyle(.iconOnly)
                }
            }
            
            // Bottom Toolbar
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                // Create new note
                Button {
                    let note = Note()
                    folderManager.createNote(note: note, folder: folder)
                    noteId = note.id
                } label: {
                    Label("New Note", systemImage: "square.and.pencil")
                }
            }
        }
        
    }
}

#if DEBUG
struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(folder: .constant(FolderManager().folders[0]), noteId: .constant(UUID()))
            .environmentObject(FolderManager())
        NoteListView(folder: .constant(FolderManager().folders[0]), noteId: .constant(UUID()))
            .environmentObject(FolderManager())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif
