//
//  Bundle-String-Array.swift
//  Screenable
//
//  Created by Weerawut on 14/1/2569 BE.
//

import Foundation

extension Bundle {
    func loadStringArray(from file: String) -> [String] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in Bundle.")
        }
        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Failed to load \(file) from Bundle.")
        }
        return string.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
    }
}
