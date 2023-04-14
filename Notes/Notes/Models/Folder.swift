//
//  Folder.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation

struct Folder: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var notes: [Note]
    var required = false

    enum CodingKeys: String, CodingKey {
        case id, title, notes
    }
    
    func note(_ id: UUID) -> Note? {
        let note = notes.first(where: { $0.id == id })
        return note
    }
    
    func noteIndex(_ id: UUID) -> Int? {
        let index = notes.firstIndex(where: { $0.id == id })
        return index
    }
    
    func hasNote(_ note: Note) -> Bool {
        return noteIndex(note.id) != nil
    }
}
