//
//  Note.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation

struct Note: Identifiable, Hashable, Codable {
    let id: UUID = UUID()
    let created = Date()
    var folderId: UUID? = nil
    var text: String = ""

    enum CodingKeys: String, CodingKey {
        case id, created, folderId, text
    }
}
