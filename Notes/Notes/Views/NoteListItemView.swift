//
//  NoteListItemView.swift
//  Notes
//
//  Created by Drew Miller on 4/19/23.
//

import SwiftUI

struct NoteListItemView: View {
    @EnvironmentObject var folderManager: FolderManager
    let note: Note

    var folderTitle: String {
        let folder = folderManager.getFolder(note: note)
        return folder?.title ?? "Notes"
    }
    
    var body: some View {
        NavigationLink(value: note, label: {
            VStack(alignment: .leading, spacing: 7) {
                Text(note.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text(!note.text.isEmpty ? note.text : "No text")
                    .font(.subheadline)
                
                Label(folderTitle, systemImage: "folder")
                    .font(.subheadline)
            }
        })
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                folderManager.deleteNote(note)
            } label: {
                Label("Delete", systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
            
            Button {
                // folderManager.deleteNote(note)
                print("Move Note")
            } label: {
                Label("Move", systemImage: "folder")
                    .labelStyle(.iconOnly)
            }
            .tint(.indigo)
        }
    }
}

#if DEBUG
struct NoteListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif
