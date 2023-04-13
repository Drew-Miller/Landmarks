//
//  AppState.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation
import SwiftUI

extension String {
    static let defaultKeys = UserDefaultKeys()
    
    class UserDefaultKeys {
        let folders: String = "folders"
        let notes: String = "notes"
    }
}

@MainActor
class FolderManager: ObservableObject {
    @AppStorage("folders") var foldersData: Data = Data()
    
    @Published var folders: [Folder] = []
    
    init() {
        loadData()
    }
    
    private func loadData() {
        if let decodedData = try? JSONDecoder().decode([Folder].self, from: foldersData) {
            folders = decodedData
        }
    }
    
    private func saveData() {
        if let encodedData = try? JSONEncoder().encode(folders) {
            foldersData = encodedData
        }
    }
    
    func addFolder(title: String) {
        let newFolder = Folder(title: title, notes: [])
        folders.append(newFolder)
        saveData()
    }
    
    func deleteFolder(folder: Folder) {
        if let index = folders.firstIndex(where: { $0.id == folder.id }) {
            folders.remove(at: index)
            saveData()
        }
    }
    
    func addNoteToFolder(note: Note, folder: Folder) {
        if let index = folders.firstIndex(where: { $0.id == folder.id }) {
            var updatedFolder = folder
            updatedFolder.notes.append(note)
            folders[index] = updatedFolder
            saveData()
        }
    }
}
