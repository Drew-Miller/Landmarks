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
    @State var text = "Hello, world!"
    @FocusState var focused: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                TextEditor(text: $text)
                    .focused($focused)
                    .scrollContentBackground(.hidden)
                    .background(.red)
            }
            .onTapGesture {
                focused = true
            }
        }
        .onChange(of: note) { note in
            if let note = note {
                text = note.text
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
