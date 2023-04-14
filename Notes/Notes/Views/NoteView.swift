//
//  NoteView.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

struct NoteView: View {
    @StateObject var folderManager = FolderManager()
    @Binding var note: Note
    @State var text = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .border(Color.gray, width: 1)
                .padding()
        }
        .onAppear {
            text = note.text
        }
        .onChange(of: text) { text in
            folderManager.saveNote(note: note, text: text)
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
