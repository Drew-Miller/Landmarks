//
//  Folder.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation

struct Folder: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let notes: [Note]
}
