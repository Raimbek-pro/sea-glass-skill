//
//  SeaGlassButton.swift
//  SeaGlass
//
//  Tactile sand-tumbled button with physical spring depress and light haptics.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct SeaGlassButtonStyle: ButtonStyle {
    public var palette: SeaGlassPalette
    public var shape: SeaGlassShape
    public var elevation: CGFloat

    public init(
        palette: SeaGlassPalette = .lagoon,
        shape: SeaGlassShape = .capsule,
        elevation: CGFloat = 8
    ) {
        self.palette = palette
        self.shape = shape
        self.elevation = elevation
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded).weight(.medium))
            .foregroundColor(palette.ink)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .modifier(
                SeaGlassModifier(
                    palette: palette,
                    shape: shape,
                    elevation: configuration.isPressed ? max(1, elevation * 0.25) : elevation,
                    frost: 0.65,
                    thickness: 6,
                    isDepressed: configuration.isPressed
                )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    #if canImport(UIKit)
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    #endif
                }
            }
    }
}

public struct SeaGlassButton<Content: View>: View {
    public let action: () -> Void
    public var palette: SeaGlassPalette
    public var shape: SeaGlassShape
    public var elevation: CGFloat
    public let label: () -> Content

    public init(
        palette: SeaGlassPalette = .lagoon,
        shape: SeaGlassShape = .capsule,
        elevation: CGFloat = 8,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Content
    ) {
        self.action = action
        self.palette = palette
        self.shape = shape
        self.elevation = elevation
        self.label = label
    }

    public var body: some View {
        Button(action: action) {
            label()
        }
        .buttonStyle(
            SeaGlassButtonStyle(
                palette: palette,
                shape: shape,
                elevation: elevation
            )
        )
    }
}
