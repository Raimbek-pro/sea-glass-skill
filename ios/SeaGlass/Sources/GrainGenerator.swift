//
//  GrainGenerator.swift
//  SeaGlass
//
//  Procedural sand-tumbled micro-grain texture overlay.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct GrainOverlayView: View {
    public var opacity: Double = 0.08

    public init(opacity: Double = 0.08) {
        self.opacity = opacity
    }

    public var body: some View {
        Canvas { context, size in
            // Generate deterministic subtle micro-grain speckles
            var seed: UInt64 = 42
            func nextRandom() -> Double {
                seed = seed &* 6364136223846793005 &+ 1442695040888963407
                return Double(seed >> 32) / Double(UInt32.max)
            }

            let step: CGFloat = 3.0
            var y: CGFloat = 0
            while y < size.height {
                var x: CGFloat = 0
                while x < size.width {
                    let r = nextRandom()
                    if r > 0.65 {
                        let alpha = (r - 0.65) * 0.4
                        let rect = CGRect(x: x, y: y, width: 1.5, height: 1.5)
                        context.fill(
                            Path(rect),
                            with: .color(Color.white.opacity(alpha * opacity * 2.5))
                        )
                    } else if r < 0.25 {
                        let alpha = (0.25 - r) * 0.3
                        let rect = CGRect(x: x, y: y, width: 1.5, height: 1.5)
                        context.fill(
                            Path(rect),
                            with: .color(Color.black.opacity(alpha * opacity * 1.8))
                        )
                    }
                    x += step
                }
                y += step
            }
        }
        .blendMode(.overlay)
        .allowsHitTesting(false)
    }
}
