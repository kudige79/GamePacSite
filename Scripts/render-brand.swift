#!/usr/bin/env swift

import AppKit

struct Palette {
    let accent: NSColor
    let outerFill: NSColor
    let outerStroke: NSColor
    let cardFill: NSColor
    let cardStroke: NSColor
}

let light = Palette(
    accent: NSColor(srgbRed: 0.0, green: 87.0 / 255.0, blue: 200.0 / 255.0, alpha: 1),
    outerFill: NSColor(srgbRed: 209.0 / 255.0, green: 215.0 / 255.0, blue: 226.0 / 255.0, alpha: 1),
    outerStroke: NSColor(srgbRed: 166.0 / 255.0, green: 177.0 / 255.0, blue: 191.0 / 255.0, alpha: 1),
    cardFill: NSColor(srgbRed: 1, green: 1, blue: 1, alpha: 1),
    cardStroke: NSColor(srgbRed: 188.0 / 255.0, green: 198.0 / 255.0, blue: 211.0 / 255.0, alpha: 1)
)

let dark = Palette(
    accent: NSColor(srgbRed: 120.0 / 255.0, green: 183.0 / 255.0, blue: 1, alpha: 1),
    outerFill: NSColor(srgbRed: 53.0 / 255.0, green: 65.0 / 255.0, blue: 81.0 / 255.0, alpha: 1),
    outerStroke: NSColor(srgbRed: 91.0 / 255.0, green: 108.0 / 255.0, blue: 130.0 / 255.0, alpha: 1),
    cardFill: NSColor(srgbRed: 38.0 / 255.0, green: 49.0 / 255.0, blue: 61.0 / 255.0, alpha: 1),
    cardStroke: NSColor(srgbRed: 98.0 / 255.0, green: 117.0 / 255.0, blue: 141.0 / 255.0, alpha: 1)
)

func drawRoundedRect(_ rect: NSRect, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil, lineWidth: CGFloat = 1) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    if let stroke {
        stroke.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}

func drawMark(in rect: NSRect, palette: Palette) {
    let side = min(rect.width, rect.height)
    let markRect = NSRect(
        x: rect.midX - side / 2,
        y: rect.midY - side / 2,
        width: side,
        height: side
    )
    let outerInset = side * 0.04
    let outer = markRect.insetBy(dx: outerInset, dy: outerInset)
    drawRoundedRect(
        outer,
        radius: side * 0.22,
        fill: palette.outerFill,
        stroke: palette.outerStroke,
        lineWidth: max(1, side * 0.012)
    )

    let padding = side * 0.19
    let gap = side * 0.075
    let cardSide = (side - (padding * 2) - gap) / 2
    let origins = [
        NSPoint(x: markRect.minX + padding, y: markRect.midY + gap / 2),
        NSPoint(x: markRect.midX + gap / 2, y: markRect.midY + gap / 2),
        NSPoint(x: markRect.minX + padding, y: markRect.minY + padding),
        NSPoint(x: markRect.midX + gap / 2, y: markRect.minY + padding)
    ]

    for (index, origin) in origins.enumerated() {
        let card = NSRect(origin: origin, size: NSSize(width: cardSide, height: cardSide))
        drawRoundedRect(
            card,
            radius: side * 0.065,
            fill: index == 0 ? palette.accent : palette.cardFill,
            stroke: index == 0 ? palette.accent : palette.cardStroke,
            lineWidth: max(1, side * 0.009)
        )
    }
}

func makePNG(width: Int, height: Int, draw: (NSRect) -> Void) -> Data {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
        fatalError("Could not create bitmap context")
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    NSColor.clear.setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()
    draw(NSRect(x: 0, y: 0, width: width, height: height))
    context.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()

    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("Could not encode PNG")
    }
    return data
}

func roundedFont(size: CGFloat, weight: NSFont.Weight) -> NSFont {
    let base = NSFont.systemFont(ofSize: size, weight: weight)
    if let descriptor = base.fontDescriptor.withDesign(.rounded),
       let font = NSFont(descriptor: descriptor, size: size) {
        return font
    }
    return base
}

guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: render-brand.swift OUTPUT_DIRECTORY")
}

let outputDirectory = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)

let markLight = makePNG(width: 512, height: 512) { rect in
    drawMark(in: rect, palette: light)
}
try markLight.write(to: outputDirectory.appendingPathComponent("game-pac-mark-light.png"), options: .atomic)

let markDark = makePNG(width: 512, height: 512) { rect in
    drawMark(in: rect, palette: dark)
}
try markDark.write(to: outputDirectory.appendingPathComponent("game-pac-mark-dark.png"), options: .atomic)

let favicon = makePNG(width: 64, height: 64) { rect in
    drawMark(in: rect, palette: light)
}
try favicon.write(to: outputDirectory.appendingPathComponent("favicon.png"), options: .atomic)

let social = makePNG(width: 1200, height: 630) { rect in
    NSColor(srgbRed: 245.0 / 255.0, green: 247.0 / 255.0, blue: 250.0 / 255.0, alpha: 1).setFill()
    rect.fill()

    let halo = NSBezierPath(ovalIn: NSRect(x: 660, y: 25, width: 540, height: 540))
    NSColor(srgbRed: 0.0, green: 87.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.08).setFill()
    halo.fill()

    drawMark(in: NSRect(x: 770, y: 145, width: 340, height: 340), palette: light)

    let titleStyle: [NSAttributedString.Key: Any] = [
        .font: roundedFont(size: 90, weight: .bold),
        .foregroundColor: NSColor(srgbRed: 21.0 / 255.0, green: 32.0 / 255.0, blue: 51.0 / 255.0, alpha: 1)
    ]
    let captionStyle: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 32, weight: .medium),
        .foregroundColor: NSColor(srgbRed: 82.0 / 255.0, green: 97.0 / 255.0, blue: 116.0 / 255.0, alpha: 1)
    ]

    NSString(string: "Game Pac").draw(at: NSPoint(x: 90, y: 325), withAttributes: titleStyle)
    NSString(string: "Native macOS games, made all the way down.").draw(
        in: NSRect(x: 94, y: 214, width: 585, height: 88),
        withAttributes: captionStyle
    )
}
try social.write(to: outputDirectory.appendingPathComponent("og-game-pac.png"), options: .atomic)
