//
//  SeaGlassPalette.swift
//  SeaGlass
//
//  Created for Sea Glass iOS / Liquid Glass
//  Universal coastal palettes with volumetric pigment, rim catch, and ink colors.
//

import SwiftUI

public struct SeaGlassPalette: Sendable, Hashable, Identifiable {
    public var id: String { name }
    
    public let name: String
    public let body: Color
    public let edge: Color
    public let ink: Color
    public let halo: Color
    public let accent: Color

    public init(
        name: String,
        body: Color,
        edge: Color,
        ink: Color,
        halo: Color,
        accent: Color
    ) {
        self.name = name
        self.body = body
        self.edge = edge
        self.ink = ink
        self.halo = halo
        self.accent = accent
    }

    /// Soft oceanic sea blue
    public static let lagoon = SeaGlassPalette(
        name: "Lagoon",
        body: Color(red: 0.710, green: 0.816, blue: 0.922), // #B5D0EB
        edge: Color(red: 0.839, green: 0.914, blue: 1.000), // #D6E9FF
        ink: Color(red: 0.184, green: 0.392, blue: 0.486),  // #2F647C
        halo: Color(red: 0.710, green: 0.816, blue: 0.922).opacity(0.45),
        accent: Color(red: 0.184, green: 0.525, blue: 0.725)
    )

    /// Coastal tide green
    public static let mint = SeaGlassPalette(
        name: "Mint",
        body: Color(red: 0.753, green: 0.871, blue: 0.816), // #C0DED0
        edge: Color(red: 0.902, green: 1.000, blue: 0.941), // #E6FFF0
        ink: Color(red: 0.224, green: 0.424, blue: 0.353),  // #396C5A
        halo: Color(red: 0.753, green: 0.871, blue: 0.816).opacity(0.45),
        accent: Color(red: 0.200, green: 0.600, blue: 0.450)
    )

    /// Blush sunset coral
    public static let rose = SeaGlassPalette(
        name: "Rose",
        body: Color(red: 0.933, green: 0.808, blue: 0.839), // #EECED6
        edge: Color(red: 1.000, green: 0.941, blue: 0.945), // #FFF0F1
        ink: Color(red: 0.588, green: 0.247, blue: 0.349),  // #963F59
        halo: Color(red: 0.933, green: 0.808, blue: 0.839).opacity(0.45),
        accent: Color(red: 0.850, green: 0.280, blue: 0.420)
    )

    /// Warm honey beach glass
    public static let amber = SeaGlassPalette(
        name: "Amber",
        body: Color(red: 0.941, green: 0.851, blue: 0.745), // #F0D9BE
        edge: Color(red: 1.000, green: 0.988, blue: 0.878), // #FFFCE0
        ink: Color(red: 0.525, green: 0.341, blue: 0.200),  // #865733
        halo: Color(red: 0.941, green: 0.851, blue: 0.745).opacity(0.45),
        accent: Color(red: 0.800, green: 0.450, blue: 0.150)
    )

    /// Soft violet drift
    public static let lilac = SeaGlassPalette(
        name: "Lilac",
        body: Color(red: 0.882, green: 0.804, blue: 0.910), // #E1CDE8
        edge: Color(red: 0.984, green: 0.910, blue: 0.969), // #FBE8F7
        ink: Color(red: 0.443, green: 0.220, blue: 0.545),  // #71388B
        halo: Color(red: 0.882, green: 0.804, blue: 0.910).opacity(0.45),
        accent: Color(red: 0.650, green: 0.280, blue: 0.820)
    )

    public static let all: [SeaGlassPalette] = [.lagoon, .mint, .rose, .amber, .lilac]
}

private struct SeaGlassPaletteKey: EnvironmentKey {
    static let defaultValue: SeaGlassPalette = .lagoon
}

public extension EnvironmentValues {
    var seaGlassPalette: SeaGlassPalette {
        get { self[SeaGlassPaletteKey.self] }
        set { self[SeaGlassPaletteKey.self] = newValue }
    }
}
