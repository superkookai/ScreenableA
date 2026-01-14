//
//  Color-Codable.swift
//  Screenable
//
//  Created by Weerawut on 14/1/2569 BE.
//

import SwiftUI

extension Color: @retroactive Decodable {}
extension Color: @retroactive Encodable {}
extension Color {
    enum CodingKeys: CodingKey {
        case red, green, blue, alpha
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        let a = try container.decode(Double.self, forKey: .alpha)
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.getComponents().red, forKey: .red)
        try container.encode(self.getComponents().green, forKey: .green)
        try container.encode(self.getComponents().blue, forKey: .blue)
        try container.encode(self.getComponents().alpha, forKey: .alpha)
    }
    
    func getComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        let color = NSColor(self).usingColorSpace(.sRGB)
        color?.getRed(&r, green: &g, blue: &b, alpha: &a)

        return (r, g, b, a)
    }
}
