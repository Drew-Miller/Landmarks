//
//  Folder.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation

struct Folder: Identifiable, Hashable, Codable {
    let id: UUID = UUID()
    var title: String
    var notes: [Note]

    enum CodingKeys: String, CodingKey {
        case id, title, notes
    }
}
