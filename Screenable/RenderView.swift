//
//  RenderView.swift
//  Screenable
//
//  Created by Weerawut on 14/1/2569 BE.
//

import SwiftUI

struct RenderView: View {
    let document: ScreenableDocument
    
    var body: some View {
        Canvas { context, size in
            // set up
            let fullSizeRect = CGRect(origin: .zero, size: size)
            let fullSizePath = Path(fullSizeRect)
            let phoneSize = CGSize(width: 300, height: 607)
            let imageInsets = CGSize(width: 16, height: 14)
            // draw the background image
            context.fill(fullSizePath, with: .color(.white))
            if !document.backgroundImage.isEmpty {
                context.draw(Image(document.backgroundImage), in: fullSizeRect)
            }
            // add a gradient
            context.fill(fullSizePath, with: .linearGradient(Gradient(colors: [document.backgroundColorTop, document.backgroundColorBottom]), startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height)))
            // draw the caption
            var verticalOffset = 0.0
            let horizontalOffset = (size.width - phoneSize.width) / 2
            if document.caption.isEmpty {
                verticalOffset = (size.height - phoneSize.height) / 2
            } else {
                if let resolvedCaption = context.resolveSymbol(id: "Text") {
                    let textPosition = (size.width - resolvedCaption.size.width) / 2
                    context.draw(resolvedCaption, in: CGRect(origin: CGPoint(x: textPosition, y: 20), size: resolvedCaption.size))
                    verticalOffset = resolvedCaption.size.height + 40
                }
            }
            // draw the phone and screenshot
            if document.dropShadowStrength > 1 {
                var contextCopy = context
                contextCopy.addFilter(.shadow(color: .black, radius: Double(document.dropShadowStrength)))
                contextCopy.addFilter(.shadow(color: .black, radius: Double(document.dropShadowStrength)))
                contextCopy.draw(Image("iPhone"), in: CGRect(origin: CGPoint(x: horizontalOffset, y: verticalOffset), size: phoneSize))
            }
            
            if let screenShot = context.resolveSymbol(id: "Image") {
                let drawPosition = CGPoint(x: horizontalOffset+imageInsets.width, y: verticalOffset+imageInsets.height)
                let drawSize = CGSize(width: phoneSize.width-2*imageInsets.width, height: phoneSize.height-2*imageInsets.height)
                context.draw(screenShot, in: CGRect(origin: drawPosition, size: drawSize))
            }
            
            
            context.draw(Image("iPhone"), in: CGRect(origin: CGPoint(x: horizontalOffset, y: verticalOffset), size: phoneSize))
            
        } symbols: {
            // add custom SwiftUI views
            Text(document.caption)
                .font(.custom(document.font, size: Double(document.fontSize)))
                .foregroundStyle(document.captionColor)
                .multilineTextAlignment(.center)
                .shadow(color: document.dropShadowLocation == 1 || document.dropShadowLocation == 3 ? .black : .clear, radius: Double(document.dropShadowStrength))
                .shadow(color: document.dropShadowLocation == 1 || document.dropShadowLocation == 3 ? .black : .clear, radius: Double(document.dropShadowStrength))
                .tag("Text")
            
            if let userImage = document.userImage, let nsImage = NSImage(data: userImage) {
                Image(nsImage: nsImage)
                    .tag("Image")
            } else {
                Color.gray
                    .tag("Image")
            }
        }
        .frame(width: 414, height: 736)
    }
}

#Preview {
    var document = ScreenableDocument()
    document.caption = "Hello, RenderView!"
    return RenderView(document: document)
}
