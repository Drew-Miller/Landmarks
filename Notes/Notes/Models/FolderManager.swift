//
//  AppState.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation
import SwiftUI

@MainActor
final class FolderManager: ObservableObject {
    @AppStorage("folders") private var foldersData: Data?
    
    var folders: [Folder] {
        get {
            if let data = foldersData,
               let savedFolders = try? JSONDecoder().decode([Folder].self, from: data) {
                return savedFolders
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                foldersData = encoded
            }
        }
    }
    
    var allNotes: [Note] {
        folders.flatMap { $0.notes }
    }
    
    func allTags() -> Set<String> {
        var tags = Set<String>()
        
        allNotes.forEach { tags.formUnion($0.getTags()) }
        
        return tags
    }
    
    init() {
        if let data = foldersData,
           let savedFolders = try? JSONDecoder().decode([Folder].self, from: data) {
            folders = savedFolders
        }
        
        if !folderExists(withTitle: "Notes") {
            // Add some sample folders
            let notesFolder = Folder(title: "Notes", notes: [], required: true)
            
            let defaultFolders = [notesFolder]
            
            if folders.isEmpty {
                folders = defaultFolders
            } else {
                folders.insert(contentsOf: defaultFolders, at: 0)
            }
        }
        
        if let index = folderIndex(withTitle: "Notes") {
            let notesFolder = folders[index]
            guard notesFolder.notes.isEmpty else {
                return
            }
            
            createNote(note: Note())
        }
    }
    
    private func folderIndex(withTitle title: String) -> Int? {
        return folders.firstIndex(where: {
            $0.title.caseInsensitiveCompare(title) == .orderedSame
        })
    }
    
    private func folderExists(withTitle title: String) -> Bool {
        return folderIndex(withTitle: title) != nil
    }
    
    private func getContainingFolder(note: Note, index: Bool = false) -> Folder? {
        return folders.first(where: { $0.hasNote(note) })
            
    }
    
    func folder(id: UUID, index: Bool = false) -> Folder? {
        let folders = folders
        return folders.first(where: { $0.id == id })
    }
    
    func addFolder(title: String) {
        guard folderExists(withTitle: title) else {
            return
        }
        
        let newFolder = Folder(title: title, notes: [])
        folders.append(newFolder)
    }
    
    func deleteFolder(folder: Folder) {
        if let index = folders.firstIndex(where: { $0.id == folder.id && !$0.required }) {
            folders.remove(at: index)
        }
    }
    
    func createNote(note: Note) {
        if let index = folderIndex(withTitle: "Notes") {
            var notesFolder = folders[index]
            notesFolder.notes.append(note)
            folders[index] = notesFolder
        }
    }
    
    func moveNoteToFolder(note: Note, to destination: Folder) {
        guard var sourceFolder = getContainingFolder(note: note) else {
            print("Error: Failed to find source folder")
            return
        }
        
        if let index = sourceFolder.noteIndex(note.id), let destinationIndex = folders.firstIndex(where: { destination.id == $0.id }) {
            sourceFolder.notes.remove(at: index)
            folders[destinationIndex].notes.append(note)
        }
    }
    
    func saveNote(note: Note, text: String) {
        if var folder = getContainingFolder(note: note), let folderIndex = folderIndex(withTitle: folder.title), let noteIndex = folder.noteIndex(note.id) {
            // Note is already in a folder, update the folder
            var updatedNote = note
            updatedNote.text = text
            updatedNote.modified = Date()
            folder.notes[noteIndex] = updatedNote
            folders[folderIndex] = folder
        }
    }
    
    func deleteNote(_ note: Note) {
        if var folder = getContainingFolder(note: note), let folderIndex = folderIndex(withTitle: folder.title), let noteIndex = folder.noteIndex(note.id) {
            // Note is already in a folder, update the folder
            folder.notes.remove(at: noteIndex)
            folders[folderIndex] = folder
            
            if allNotes.isEmpty {
                createNote(note: Note())
            }
        }
    }
}
