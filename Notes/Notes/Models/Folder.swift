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
        case id, title, notes, required
    }
    
    func get(id: UUID) -> Note? {
        let note = notes.first(where: { $0.id == id })
        return note
    }
    
    func index(id: UUID) -> Int? {
        let index = notes.firstIndex(where: { $0.id == id })
        return index
    }
    
    func exists(note: Note) -> Bool {
        let hasNote = get(id: note.id) != nil
        return hasNote
    }
}
