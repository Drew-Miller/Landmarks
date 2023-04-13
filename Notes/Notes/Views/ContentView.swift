//
//  ContentView.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import SwiftUI

struct DemoContentView: View {
    @StateObject private var appState = AppState()
    @State private var columnVisibility =
        NavigationSplitViewVisibility.detailOnly
    
    var body: some View {
        Text("Hello, world!")
//        List(appState.folders) { folder in
//            Text(folder.title)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct ContentView: View {
    enum Views: String, CaseIterable {
        case simple = "Simple"
        case navigationStack = "Navigation Stack"
        case noTitle = "No Title"
    }
    
    @State var navView: Views? = nil
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    var body: some View {
        NavigationSplitView {
            List(selection: $navView) {
                Section {
                    ForEach(Views.allCases, id: \.self) {view in
                        NavigationLink(value: view, label: {
                            Label("Content \(view.rawValue)", systemImage: "folder")
                        })
                    }
                } header: {
                    Text("iCloud")
                }
            }
            .navigationTitle("Folders")
        } content: {
            Text("content view")
        } detail: {
            ZStack {
                switch (navView) {
                
                case .simple:
                    Text("Content Simple Links")
                    
                case .navigationStack:
                    NavigationStack {
                        List {
                            NavigationLink {
                                Text("Hello, world!")
                            } label: {
                                Text("Hello, world!")
                            }
                            
                            NavigationLink {
                                VStack {
                                    Text("Nested Links")
                                    
                                    NavigationLink {
                                        Text("Inside nested link")
                                    } label: {
                                        Text("Go to nested link")
                                    }
                                }
                                .navigationTitle("Nested Links")
                                
                            } label: {
                                Text("Nested Links")
                            }
                        }
                    }
                    .navigationTitle("Navigation Stack")
                    
                case .noTitle:
                    NavigationStack {
                        List {
                            NavigationLink {
                                Text("Hello, world!")
                            } label: {
                                Text("Hello, world!")
                            }
                        }
                    }
                    // 'Back' by default
                    .navigationTitle("")
                    
                default:
                    Text("Hello, world!")
                }
            }
        }
    }
}
