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
final class AppState: ObservableObject {
    //@AppStorage("folders") private(set) var folders: [Folder] = [Folder]()
}
