//
//  NoteListView.swift
//  Notes
//
//  Created by Drew Miller on 4/19/23.
//

import SwiftUI

struct NoteListView: View {
    @EnvironmentObject var folderManager: FolderManager
    @Binding var folder: Folder?
    @Binding var note: Note?
    @State var search = ""
    @State var createNote = false
    
    var body: some View {
        NavigationStack {
            List(selection: $note) {
                if folder == nil || folder!.notes.isEmpty {
                    Text("ListFix")
                        .hidden()
                        .accessibility(hidden: true)
                        .listRowBackground(Color.clear)
                }
                
                ForEach(folder?.notes ?? [], id: \.self) { note in
                    NoteListItemView(note: note)
                        .environmentObject(folderManager)
                }
            }
        }
#if os(iOS)
        .navigationTitle(folder?.title ?? "Notes")
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
                    note = folderManager.createNote(folder: folder!)
                } label: {
                    Label("New Note", systemImage: "square.and.pencil")
                }
                .disabled(folder == nil)
            }
        }
    }
}

#if DEBUG
struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif
