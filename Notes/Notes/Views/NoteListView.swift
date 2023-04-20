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
    @Binding var notes: [Note]
    @Binding var noteId: UUID?
    
    var body: some View {
        List(selection: $noteId) {
            Section {
                ForEach(notes, id: \.self) { note in
                    NavigationLink(value: note.id, label: {
                        VStack {
                            Text(note.title)
                        }
                    })
                }
            } header: {
                Text("Notes")
            }
        }
#if os(iOS)
        .navigationTitle(folderTitle)
#endif
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
