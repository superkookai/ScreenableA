//
//  ContentView.swift
//  Screenable
//
//  Created by Weerawut on 14/1/2569 BE.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: ScreenableDocument
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")
    
    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
                .dropDestination(for: URL.self) { items, session in
                    handleDrop(of: items)
                }
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Caption")
                        .bold()
                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)
                    Picker("Select Caption Font", selection: $document.font) {
                        ForEach(fonts, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Size of Caption Font", selection: $document.fontSize) {
                        ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) {
                            Text("\($0)pt")
                        }
                    }
                }
                .labelsHidden()
                
                VStack(alignment: .leading) {
                    Text("Background image")
                        .bold()
                    Picker("Background images", selection: $document.backgroundImage) {
                        Text("No Background")
                            .tag("")
                        Divider()
                        ForEach(backgrounds, id: \.self) {
                            Text($0)
                                .tag($0)
                        }
                    }
                }
                .labelsHidden()
            }
            .frame(width: 250)
        }
        .padding()
    }
    
    func handleDrop(of urls: [URL]) -> Bool {
        guard let url = urls.first else { return false }
        document.userImage = try? Data(contentsOf: url)
        return true
    }
}

#Preview {
    ContentView(document: .constant(ScreenableDocument()))
}
