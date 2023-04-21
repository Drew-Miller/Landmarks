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
    let folderTitle: String

    var body: some View {
        NavigationLink(value: note.id, label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(note.title)
                    .font(.headline)
                
                Text(!note.text.isEmpty ? note.text : "No text")
                
                Label(folderTitle, systemImage: "folder")
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
                folderManager.deleteNote(note)
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
        NoteListItemView(note: Note(), folderTitle: "All Notes")
        NoteListItemView(note: Note(), folderTitle: "All Notes")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif
