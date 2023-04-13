//
//  Note.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation

struct Note: Identifiable, Hashable {
    var id: UUID = UUID()
    var folderId: UUID? = nil
    var title: String
    var text: String
}
