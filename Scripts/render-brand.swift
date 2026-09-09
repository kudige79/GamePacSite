#!/usr/bin/env swift

import AppKit

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

func loadImage(_ url: URL) -> NSImage {
    guard let image = NSImage(contentsOf: url) else {
        fatalError("Could not load image at \(url.path)")
    }
    return image
}

func drawArcadeMark(_ image: NSImage, in rect: NSRect) {
    image.draw(
        in: rect,
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
}

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

func drawIconCard(_ image: NSImage, in rect: NSRect, fill: NSColor) {
    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.35)
    shadow.shadowBlurRadius = 22
    shadow.shadowOffset = NSSize(width: 0, height: -10)
    shadow.set()
    drawRoundedRect(
        rect,
        radius: 30,
        fill: fill,
        stroke: NSColor.white.withAlphaComponent(0.18),
        lineWidth: 2
    )
    NSGraphicsContext.restoreGraphicsState()

    image.draw(
        in: rect.insetBy(dx: 13, dy: 13),
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
}

let arguments = CommandLine.arguments
guard arguments.count >= 2 else {
    fatalError("Usage: render-brand.swift OUTPUT_DIRECTORY [ICON_SOURCE]")
}

let outputDirectory = URL(fileURLWithPath: arguments[1], isDirectory: true)
let iconSourcePath: String
if arguments.count >= 3 {
    iconSourcePath = arguments[2]
} else if let environmentSource = ProcessInfo.processInfo.environment["GAMEPAC_ICON_SOURCE"] {
    iconSourcePath = environmentSource
} else {
    fatalError("Pass the approved arcade icon source as argument 2 or set GAMEPAC_ICON_SOURCE")
}

let arcadeIcon = loadImage(URL(fileURLWithPath: iconSourcePath))
let mineIcon = loadImage(outputDirectory.appendingPathComponent("minesweeper-icon.png"))
let dottieIcon = loadImage(outputDirectory.appendingPathComponent("dottie-icon.png"))
let tillyIcon = loadImage(outputDirectory.appendingPathComponent("tilly-icon.png"))
let sukiIcon = loadImage(outputDirectory.appendingPathComponent("suki-icon.png"))

let mark = makePNG(width: 84, height: 84) { rect in
    drawArcadeMark(arcadeIcon, in: rect)
}
try mark.write(to: outputDirectory.appendingPathComponent("game-pac-mark-light.png"), options: .atomic)
try mark.write(to: outputDirectory.appendingPathComponent("game-pac-mark-dark.png"), options: .atomic)

let favicon = makePNG(width: 64, height: 64) { rect in
    drawArcadeMark(arcadeIcon, in: rect)
}
try favicon.write(to: outputDirectory.appendingPathComponent("favicon.png"), options: .atomic)

let touchIcon = makePNG(width: 180, height: 180) { rect in
    drawArcadeMark(arcadeIcon, in: rect)
}
try touchIcon.write(to: outputDirectory.appendingPathComponent("apple-touch-icon.png"), options: .atomic)

let social = makePNG(width: 1200, height: 630) { rect in
    NSColor(srgbRed: 8.0 / 255.0, green: 13.0 / 255.0, blue: 24.0 / 255.0, alpha: 1).setFill()
    rect.fill()

    NSColor.white.withAlphaComponent(0.055).setStroke()
    for x in stride(from: CGFloat(0), through: rect.width, by: 52) {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: x, y: 0))
        line.line(to: NSPoint(x: x, y: rect.height))
        line.lineWidth = 1
        line.stroke()
    }
    for y in stride(from: CGFloat(0), through: rect.height, by: 52) {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: 0, y: y))
        line.line(to: NSPoint(x: rect.width, y: y))
        line.lineWidth = 1
        line.stroke()
    }

    let blueHalo = NSBezierPath(ovalIn: NSRect(x: 700, y: 210, width: 500, height: 500))
    NSColor(srgbRed: 76.0 / 255.0, green: 110.0 / 255.0, blue: 245.0 / 255.0, alpha: 0.23).setFill()
    blueHalo.fill()

    let mintHalo = NSBezierPath(ovalIn: NSRect(x: 670, y: -190, width: 420, height: 420))
    NSColor(srgbRed: 123.0 / 255.0, green: 224.0 / 255.0, blue: 177.0 / 255.0, alpha: 0.13).setFill()
    mintHalo.fill()

    let sukiHalo = NSBezierPath(ovalIn: NSRect(x: 910, y: -40, width: 360, height: 360))
    NSColor(srgbRed: 120.0 / 255.0, green: 183.0 / 255.0, blue: 1, alpha: 0.14).setFill()
    sukiHalo.fill()

    drawIconCard(
        mineIcon,
        in: NSRect(x: 724, y: 346, width: 150, height: 150),
        fill: NSColor(srgbRed: 55.0 / 255.0, green: 58.0 / 255.0, blue: 53.0 / 255.0, alpha: 1)
    )
    drawIconCard(
        dottieIcon,
        in: NSRect(x: 932, y: 330, width: 168, height: 168),
        fill: NSColor(srgbRed: 8.0 / 255.0, green: 8.0 / 255.0, blue: 58.0 / 255.0, alpha: 1)
    )
    drawIconCard(
        tillyIcon,
        in: NSRect(x: 740, y: 92, width: 158, height: 158),
        fill: NSColor(srgbRed: 16.0 / 255.0, green: 42.0 / 255.0, blue: 35.0 / 255.0, alpha: 1)
    )
    drawIconCard(
        sukiIcon,
        in: NSRect(x: 940, y: 82, width: 168, height: 168),
        fill: NSColor(srgbRed: 23.0 / 255.0, green: 33.0 / 255.0, blue: 44.0 / 255.0, alpha: 1)
    )

    let titleStyle: [NSAttributedString.Key: Any] = [
        .font: roundedFont(size: 96, weight: .bold),
        .foregroundColor: NSColor.white
    ]
    let hookColor = NSColor(srgbRed: 143.0 / 255.0, green: 194.0 / 255.0, blue: 1, alpha: 1)
    var hookSize: CGFloat = 36
    let hookText = "Four games. One app to play."
    while hookSize > 24,
          (hookText as NSString).size(withAttributes: [.font: roundedFont(size: hookSize, weight: .bold)]).width > 620 {
        hookSize -= 1
    }
    let hookStyle: [NSAttributedString.Key: Any] = [
        .font: roundedFont(size: hookSize, weight: .bold),
        .foregroundColor: hookColor
    ]
    let captionStyle: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 27, weight: .medium),
        .foregroundColor: NSColor(srgbRed: 197.0 / 255.0, green: 205.0 / 255.0, blue: 224.0 / 255.0, alpha: 1)
    ]

    NSString(string: "Game Pac").draw(at: NSPoint(x: 78, y: 372), withAttributes: titleStyle)
    NSString(string: hookText).draw(at: NSPoint(x: 84, y: 300), withAttributes: hookStyle)
    NSString(string: "Install, verify, update, and launch\nyour collection of Mac games.").draw(
        in: NSRect(x: 87, y: 190, width: 570, height: 92),
        withAttributes: captionStyle
    )

    drawArcadeMark(arcadeIcon, in: NSRect(x: 82, y: 72, width: 82, height: 82))
    let signatureStyle: [NSAttributedString.Key: Any] = [
        .font: roundedFont(size: 22, weight: .semibold),
        .foregroundColor: NSColor(srgbRed: 184.0 / 255.0, green: 194.0 / 255.0, blue: 212.0 / 255.0, alpha: 1)
    ]
    NSString(string: "Pick a game. Go again.").draw(at: NSPoint(x: 184, y: 99), withAttributes: signatureStyle)
}
try social.write(to: outputDirectory.appendingPathComponent("og-game-pac.png"), options: .atomic)
