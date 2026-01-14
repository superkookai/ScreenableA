//
//  ContentView.swift
//  Screenable
//
//  Created by Weerawut on 14/1/2569 BE.
//

import SwiftUI
import UniformTypeIdentifiers

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
                .draggable(snapshotToURL())
            
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
                    
                    HStack {
                        Picker("Size of Caption Font", selection: $document.fontSize) {
                            ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) {
                                Text("\($0)pt")
                            }
                        }
                        
                        ColorPicker("Caption Color", selection: $document.captionColor)
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
                
                VStack(alignment: .leading) {
                    Text("Background Color")
                        .bold()
                    Text("If set to non-transparent, this will be draw over background image.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 20) {
                        ColorPicker("Start", selection: $document.backgroundColorTop)
                        ColorPicker("End", selection: $document.backgroundColorBottom)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Drop Shadow")
                        .bold()
                    Picker("Drop Shadow Location", selection: $document.dropShadowLocation) {
                        Text("None").tag(0)
                        Text("Text").tag(1)
                        Text("Device").tag(2)
                        Text("Both").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    
                    Stepper("Shadow radius: \(document.dropShadowStrength)pt", value: $document.dropShadowStrength, in: 1...20)
                }
            }
            .frame(width: 250)
        }
        .padding()
        .onCommand(#selector(AppCommands.export)) {
            export()
        }
        .toolbar {
            Button("Export", action: export)
            ShareLink(item: snapshotToURL())
        }
    }
    
    func handleDrop(of urls: [URL]) -> Bool {
        guard let url = urls.first else { return false }
        document.userImage = try? Data(contentsOf: url)
        return true
    }
    
    func snapshotToURL() -> URL {
        let url = URL.temporaryDirectory.appending(path: "ScreenableExport").appendingPathExtension("png")
        try? createSnapshot()?.write(to: url)
        return url
    }
    
    func export() {
        guard let png = createSnapshot() else { return }
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.begin { result in
            if result == .OK {
                guard let url = panel.url else { return }
                do {
                    try png.write(to: url)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    
    }
    
    func createSnapshot() -> Data? {
        let renderer = ImageRenderer(content: RenderView(document: document))
        if let tiff = renderer.nsImage?.tiffRepresentation {
            let bitmap = NSBitmapImageRep(data: tiff)
            return bitmap?.representation(using: .png, properties: [:])
        } else {
            return nil
        }
    }
}

#Preview {
    ContentView(document: .constant(ScreenableDocument()))
}
