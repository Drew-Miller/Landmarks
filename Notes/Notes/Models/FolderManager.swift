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
    
    private var myFolders: [Folder] {
        get { return JSONData.decodeArray(data: foldersData, class: Folder.self) }
        set { JSONData.encode(encode: newValue) { encoded in foldersData = encoded} }
    }
    
    var folders: [Folder] {
        var folders = [Folder(title: "All Notes", notes: allNotes, required: true)]
        folders.append(contentsOf: myFolders)
        return folders
    }
    
    var allNotes: [Note] {
        myFolders.flatMap { $0.notes }
    }
    
    func allTags() -> Set<String> {
        var tags = Set<String>()
        
        allNotes.forEach { tags.formUnion($0.getTags()) }
        
        return tags
    }
    
    init() {
        if let data = foldersData,
           let savedFolders = try? JSONDecoder().decode([Folder].self, from: data) {
            myFolders = savedFolders
        }
        
        if !folderExists(withTitle: "Notes") {
            // Add some sample folders
            let notesFolder = Folder(title: "Notes", notes: [], required: true)
            
            let defaultFolders = [notesFolder]
            
            if myFolders.isEmpty {
                myFolders = defaultFolders
            } else {
                myFolders.insert(contentsOf: defaultFolders, at: 0)
            }
        }
        
        if let index = folderIndex(withTitle: "Notes") {
            var notesFolder = myFolders[index]
            notesFolder.required = true
            myFolders[index] = notesFolder
            guard notesFolder.notes.isEmpty else {
                return
            }
            
            createNote(note: Note())
        }
    }
    
    private func folderIndex(withTitle title: String) -> Int? {
        return myFolders.firstIndex(where: {
            $0.title.caseInsensitiveCompare(title) == .orderedSame
        })
    }
    
    private func folderExists(withTitle title: String) -> Bool {
        return folderIndex(withTitle: title) != nil
    }
    
    private func getContainingFolder(note: Note, index: Bool = false) -> Folder? {
        return myFolders.first(where: { $0.hasNote(note) })
            
    }
    
    func folder(id: UUID) -> Folder? {
        let folders = myFolders
        return folders.first(where: { $0.id == id })
    }
    
    func addFolder(title: String) {
        guard !folderExists(withTitle: title) else {
            return
        }
        
        let newFolder = Folder(title: title, notes: [])
        myFolders.append(newFolder)
    }
    
    func onDelete(indices: IndexSet) {
        myFolders.remove(atOffsets: indices.filteredIndexSet {
            !folders[$0].required
        })
    }
    
    func deleteFolder(folder: Folder) {
        if let index = myFolders.firstIndex(where: { $0.id == folder.id && !$0.required }) {
            myFolders.remove(at: index)
        }
    }
    
    func createNote(note: Note) {
        if let index = folderIndex(withTitle: "Notes") {
            var notesFolder = myFolders[index]
            notesFolder.notes.append(note)
            myFolders[index] = notesFolder
        }
    }
    
    func moveNoteToFolder(note: Note, to destination: Folder) {
        guard var sourceFolder = getContainingFolder(note: note) else {
            print("Error: Failed to find source folder")
            return
        }
        
        if let index = sourceFolder.noteIndex(note.id), let destinationIndex = myFolders.firstIndex(where: { destination.id == $0.id }) {
            sourceFolder.notes.remove(at: index)
            myFolders[destinationIndex].notes.append(note)
        }
    }
    
    func saveNote(note: Note, text: String) {
        if var folder = getContainingFolder(note: note), let folderIndex = folderIndex(withTitle: folder.title), let noteIndex = folder.noteIndex(note.id) {
            // Note is already in a folder, update the folder
            var updatedNote = note
            updatedNote.text = text
            updatedNote.modified = Date()
            folder.notes[noteIndex] = updatedNote
            myFolders[folderIndex] = folder
        }
    }
    
    func deleteNote(_ note: Note) {
        if var folder = getContainingFolder(note: note), let folderIndex = folderIndex(withTitle: folder.title), let noteIndex = folder.noteIndex(note.id) {
            // Note is already in a folder, update the folder
            folder.notes.remove(at: noteIndex)
            myFolders[folderIndex] = folder
            
            if allNotes.isEmpty {
                createNote(note: Note())
            }
        }
    }
}
