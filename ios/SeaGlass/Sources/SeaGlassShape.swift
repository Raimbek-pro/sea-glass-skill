//
//  SeaGlassShape.swift
//  SeaGlass
//
//  Contour shapes for sea glass: continuous rounded squircle, capsule, and disc.
//

import SwiftUI

public enum SeaGlassShape: Sendable, Hashable {
    case rounded(CGFloat = 22)
    case capsule
    case disc

    public var cornerRadius: CGFloat {
        switch self {
        case .rounded(let r): return r
        case .capsule, .disc: return 999
        }
    }
}

/// Dynamic shape wrapper providing standard InsettableShape protocol conformance
public struct AnySeaGlassShape: InsettableShape {
    public let shapeType: SeaGlassShape
    private var insetAmount: CGFloat = 0

    public init(_ shapeType: SeaGlassShape, insetAmount: CGFloat = 0) {
        self.shapeType = shapeType
        self.insetAmount = insetAmount
    }

    public func inset(by amount: CGFloat) -> AnySeaGlassShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    public func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        switch shapeType {
        case .rounded(let radius):
            let corner = max(0, min(radius - insetAmount, min(insetRect.width, insetRect.height) / 2))
            return RoundedRectangle(cornerRadius: corner, style: .continuous).path(in: insetRect)
        case .capsule:
            return Capsule(style: .continuous).path(in: insetRect)
        case .disc:
            let diameter = max(0, min(insetRect.width, insetRect.height))
            let squareRect = CGRect(
                x: insetRect.midX - diameter / 2,
                y: insetRect.midY - diameter / 2,
                width: diameter,
                height: diameter
            )
            return Circle().path(in: squareRect)
        }
    }
}
