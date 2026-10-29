//
//  SeaGlassSurface.swift
//  SeaGlass
//
//  Container surface with automatic high-contrast ink color binding.
//

import SwiftUI

public struct SeaGlassSurface<Content: View>: View {
    public var palette: SeaGlassPalette
    public var shape: SeaGlassShape
    public var elevation: CGFloat
    public var frost: CGFloat
    public let content: () -> Content

    public init(
        palette: SeaGlassPalette = .lagoon,
        shape: SeaGlassShape = .rounded(22),
        elevation: CGFloat = 8,
        frost: CGFloat = 0.55,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.palette = palette
        self.shape = shape
        self.elevation = elevation
        self.frost = frost
        self.content = content
    }

    public var body: some View {
        content()
            .environment(\.seaGlassPalette, palette)
            .seaGlass(
                palette: palette,
                shape: shape,
                elevation: elevation,
                frost: frost
            )
    }
}
