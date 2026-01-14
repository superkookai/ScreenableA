//
//  ScreenableApp.swift
//  Screenable
//
//  Created by Weerawut on 14/1/2569 BE.
//

import SwiftUI

@main
struct ScreenableApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ScreenableDocument()) { file in
            ContentView(document: file.$document)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Export...") {
                    NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
                }
                .keyboardShortcut("e")
            }
        }
    }
}
