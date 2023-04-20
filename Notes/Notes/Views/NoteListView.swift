//
//  NoteListView.swift
//  Notes
//
//  Created by Drew Miller on 4/19/23.
//

import SwiftUI

struct NoteListView: View {
    @EnvironmentObject var folderManager: FolderManager
    let folderTitle: String
    let notes: [Note]
    @Binding var noteId: UUID?
    @State var search = ""
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { note in
                NavigationLink {
                    NoteView(note: .constant(note))
                        .environmentObject(folderManager)
                } label: {
                    Text(note.title)
                }
                
                NavigationLink {
                    NoteView(note: .constant(note))
                        .environmentObject(folderManager)
                } label: {
                    Text(note.title)
                }
                NavigationLink {
                    NoteView(note: .constant(note))
                        .environmentObject(folderManager)
                } label: {
                    Text(note.title)
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $search)
        .moveDisabled(false)
        .deleteDisabled(false)
        .toolbar {
            // Top Toolbar
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation {
                        // editMode = .active
                        print("hello, world")
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                        .labelStyle(.iconOnly)
                }
            }
            
            // Bottom Toolbar
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()

                // Create new folder
                Button {
                    folderManager.createNote(note: Note())
                } label: {
                    Label("New Note", systemImage: "square.and.pencil")
                    NavigationLink(isActive: $createNote) {
                        
                    }
                }
            }
        }
#if os(iOS)
        .navigationTitle(folderTitle)
#endif
        
    }
    
    var searchResults: [Note] {
        if search.isEmpty {
            return notes
        } else {
            return notes.filter { $0.text.contains(search) }
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
