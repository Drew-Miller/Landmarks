//
//  NoteView.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

struct NoteView: View {
    @StateObject var folderManager = FolderManager()
    @Binding var note: Note?
    @State var text = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .border(Color.gray, width: 1)
                .padding()
        }
        .onAppear {
            if let note = note {
                text = note.text
            } else {
                text = "Hello, world!"
            }
        }
        .onChange(of: text) { text in
            if let note = note {
                folderManager.updateNote(note, text: text)
            }
        }
    }
}


struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: .constant(Note()))
        NoteView(note: .constant(Note()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
