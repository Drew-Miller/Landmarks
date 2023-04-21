//
//  NoteSearch.swift
//  Notes
//
//  Created by Drew Miller on 4/20/23.
//

import Foundation

class NoteSearch: ObservableObject {
    @Published var search: String = ""
    @Published var notes: [Note] = []
    
    var results: [Note] {
        if search.isEmpty {
            return notes
        } else {
            return notes.filter {
                $0.text.contains(search)
            }
        }
    }
}
