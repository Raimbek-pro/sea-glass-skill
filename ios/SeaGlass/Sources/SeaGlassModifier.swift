//
//  SeaGlassModifier.swift
//  SeaGlass
//
//  The optical modifier implementing volumetric absorption,
//  refractive rim specular, and transmitted caustic pools.
//

import SwiftUI

public struct SeaGlassModifier: ViewModifier {
    public var palette: SeaGlassPalette
    public var shape: SeaGlassShape
    public var elevation: CGFloat
    public var frost: CGFloat
    public var thickness: CGFloat
    public var isDepressed: Bool

    public init(
        palette: SeaGlassPalette = .lagoon,
        shape: SeaGlassShape = .rounded(22),
        elevation: CGFloat = 8,
        frost: CGFloat = 0.55,
        thickness: CGFloat = 6,
        isDepressed: Bool = false
    ) {
        self.palette = palette
        self.shape = shape
        self.elevation = elevation
        self.frost = frost
        self.thickness = thickness
        self.isDepressed = isDepressed
    }

    public func body(content: Content) -> some View {
        let glassShape = AnySeaGlassShape(shape)

        content
            .foregroundColor(palette.ink)
            .background {
                ZStack {
                    // 1. Transmitted ground caustic halo (Beer-Lambert light pool)
                    glassShape
                        .fill(palette.halo)
                        .blur(radius: max(2, elevation * 1.8))
                        .offset(y: elevation * 1.1)
                        .opacity(isDepressed ? 0.35 : 0.85)

                    // 2. Base ambient contact shadow
                    glassShape
                        .fill(Color.black.opacity(0.06))
                        .blur(radius: max(1, elevation * 0.7))
                        .offset(y: elevation * 0.4)

                    // 3. Apple Liquid Glass Material Blur
                    glassShape
                        .fill(.ultraThinMaterial)

                    // 4. Volumetric body color tint (Oklab coastal absorption)
                    glassShape
                        .fill(
                            LinearGradient(
                                colors: [
                                    palette.body.opacity(frost * 0.48),
                                    palette.body.opacity(frost * 0.78)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // 5. Procedural sand-tumbled micro-grain
                    glassShape
                        .fill(Color.white.opacity(0.03))
                        .overlay(
                            GrainOverlayView(opacity: 0.10)
                                .clipShape(glassShape)
                        )

                    // 6. Refractive rim catch (315° light azimuth highlight)
                    glassShape
                        .strokeBorder(
                            LinearGradient(
                                stops: [
                                    .init(color: palette.edge.opacity(0.95), location: 0.0),
                                    .init(color: palette.edge.opacity(0.35), location: 0.42),
                                    .init(color: palette.body.opacity(0.18), location: 0.72),
                                    .init(color: palette.edge.opacity(0.65), location: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isDepressed ? 1.0 : 1.5
                        )

                    // 7. Inner crescent specular reflection
                    glassShape
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.55),
                                    Color.white.opacity(0.05),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 0.85
                        )
                        .padding(1)
                }
            }
    }
}

public extension View {
    /// Applies the Sea Glass material optics to any view
    func seaGlass(
        palette: SeaGlassPalette = .lagoon,
        shape: SeaGlassShape = .rounded(22),
        elevation: CGFloat = 8,
        frost: CGFloat = 0.55,
        thickness: CGFloat = 6
    ) -> some View {
        self.modifier(
            SeaGlassModifier(
                palette: palette,
                shape: shape,
                elevation: elevation,
                frost: frost,
                thickness: thickness,
                isDepressed: false
            )
        )
    }
}
