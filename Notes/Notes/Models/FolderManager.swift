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
    @AppStorage("notes") private var notesData: Data?
    
    private var unfiledNotes: [Note] {
        get { return JSONData.decodeArray(data: notesData, class: Note.self) }
        set { JSONData.encode(encode: newValue) { encoded in notesData = encoded} }
    }
    
    private var folders: [Folder] {
        get { return JSONData.decodeArray(data: foldersData, class: Folder.self) }
        set { JSONData.encode(encode: newValue) { encoded in foldersData = encoded} }
    }
    
    private var defaultFolders: [Folder] {
        return [Folder(title: "All Notes", notes: allNotes, required: true)]
    }
    
    var allFolders: [Folder] {
        var allFolders = defaultFolders
        allFolders.append(contentsOf: folders)
        return allFolders
    }
    
    var allNotes: [Note] {
        var notes = folders.flatMap { $0.notes }
        notes.append(contentsOf: unfiledNotes)
        notes = notes.sorted {
            $0.modified > $1.modified
        }
        return notes
    }
    
    func allTags() -> Set<String> {
        var tags = Set<String>()
        
        allNotes.forEach { tags.formUnion($0.getTags()) }
        
        return tags
    }
    
    init() {
        if let data = foldersData,
           let folders = try? JSONDecoder().decode([Folder].self, from: data) {
            self.folders = folders
        }
        
        if let data = notesData,
           let notes = try? JSONDecoder().decode([Note].self, from: data) {
            unfiledNotes = notes
        }
    }
    
    private func firstIndex(withTitle title: String) -> Int? {
        return folders.firstIndex(where: {
            $0.title.caseInsensitiveCompare(title) == .orderedSame
        })
    }
    
    private func exists(withTitle title: String) -> Bool {
        return firstIndex(withTitle: title) != nil
    }
    
    func get(id: UUID) -> Folder? {
        return folders.first(where: { $0.id == id })
    }
    
    func create(title: String) {
        guard !exists(withTitle: title) else {
            return
        }
        
        let folder = Folder(title: title, notes: [])
        folders.append(folder)
    }
    
    func delete(_ folder: Folder) {
        if let index = folders.firstIndex(where: { $0.id == folder.id && !$0.required }) {
            folders.remove(at: index)
        }
    }
    
    func rename(_ folder: Folder, name: String) {
        if let index = firstIndex(withTitle: folder.title) {
            var folder = folder
            folder.title = name
            folders[index] = folder
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        let modifiedSource = IndexSet(source.map { $0 - defaultFolders.count }) // remove the default folders from the indices
        folders.move(fromOffsets: modifiedSource.filteredIndexSet {
            !folders[$0].required
        }, toOffset: destination - defaultFolders.count) // subtract the default folders indices
    }
    
    func getFolder(note: Note) -> Folder? {
        return folders.first { $0.exists(note: note) }
    }
    
    func createNote(folder: Folder? = nil) -> Note {
        let note = Note()
        if folder != nil, let index = firstIndex(withTitle: folder!.title) {
            var folder = folders[index]
            folder.notes.append(note)
            folders[index] = folder
            return note
        }
        
        unfiledNotes.append(note)
        return note
    }
    
    func deleteNote(_ note: Note) {
        if var folder = getFolder(note: note), let folderIndex = firstIndex(withTitle: folder.title), let noteIndex = folder.index(id: note.id) {
            // Note is already in a folder, update the folder
            folder.notes.remove(at: noteIndex)
            folders[folderIndex] = folder
            return
        }
        
        if let noteIndex = unfiledNotes.firstIndex(where: { $0.id == note.id }) {
            unfiledNotes.remove(at: noteIndex)
        }
    }
    
    func updateNote(_ note: Note, text: String) {
        var updatedNote = note
        updatedNote.text = text
        updatedNote.modified = Date()
        
        if var folder = getFolder(note: note), let folderIndex = firstIndex(withTitle: folder.title), let noteIndex = folder.index(id: note.id) {
            // Note is already in a folder, update the folder
            folder.notes[noteIndex] = updatedNote
            folders[folderIndex] = folder
            return
        }
        
        if let noteIndex = unfiledNotes.firstIndex(where: { $0.id == note.id }) {
            unfiledNotes[noteIndex] = updatedNote
        }
    }
    
//    func moveNote(note: Note, to destination: Folder) {
//        guard var sourceFolder = getContainingFolder(note: note) else {
//            print("Error: Failed to find source folder")
//            return
//        }
//
//        if let index = sourceFolder.noteIndex(note.id), let destinationIndex = myFolders.firstIndex(where: { destination.id == $0.id }) {
//            sourceFolder.notes.remove(at: index)
//            myFolders[destinationIndex].notes.append(note)
//        }
//    }
}
