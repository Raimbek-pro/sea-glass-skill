//
//  ShowcaseSceneView.swift
//  SeaGlassApp
//
//  Component playground for tuning palettes, shapes, elevation, and frost.
//

import SwiftUI

public struct ShowcaseSceneView: View {
    @State private var selectedPalette: SeaGlassPalette = .lagoon
    @State private var selectedShapeIndex: Int = 0
    @State private var elevation: Double = 8.0
    @State private var frost: Double = 0.58
    @State private var pressCount: Int = 0

    private let shapes: [(name: String, shape: SeaGlassShape)] = [
        ("Rounded (24pt)", .rounded(24)),
        ("Capsule", .capsule),
        ("Disc", .disc)
    ]

    public init() {}

    public var body: some View {
        ZStack {
            // Coastal gradient canvas
            LinearGradient(
                colors: [
                    selectedPalette.body.opacity(0.2),
                    Color(red: 0.92, green: 0.95, blue: 0.97)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sea Glass Optics")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(selectedPalette.ink)
                        Text("Liquid Apple Material + Physical Ocean Tumble")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(selectedPalette.ink.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Hero Specimen Card (Live Interactive Preview)
                    specimenCard
                        .padding(.horizontal, 20)

                    // Palette Selector
                    palettePicker
                        .padding(.horizontal, 20)

                    // Shape Selector
                    shapePicker
                        .padding(.horizontal, 20)

                    // Optical Controls
                    controlsCard
                        .padding(.horizontal, 20)

                    // Interactive Tactile Buttons
                    buttonsCard
                        .padding(.horizontal, 20)

                    Spacer()
                        .frame(height: 40)
                }
            }
        }
    }

    // MARK: - Specimen Card
    private var specimenCard: some View {
        let currentShape = shapes[selectedShapeIndex].shape

        return VStack(spacing: 16) {
            SeaGlassSurface(
                palette: selectedPalette,
                shape: currentShape,
                elevation: CGFloat(elevation),
                frost: CGFloat(frost)
            ) {
                VStack(spacing: 12) {
                    Image(systemName: "drop.degreesign.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(selectedPalette.accent)

                    Text(selectedPalette.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(selectedPalette.ink)

                    Text("Beer-Lambert volumetric absorption with continuous cubic B-spline contours.")
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(selectedPalette.ink.opacity(0.8))
                        .padding(.horizontal, 16)

                    HStack(spacing: 14) {
                        badge(label: "Elevation: \(Int(elevation))pt")
                        badge(label: "Frost: \(Int(frost * 100))%")
                    }
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func badge(label: String) -> some View {
        Text(label)
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundColor(selectedPalette.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .seaGlass(palette: selectedPalette, shape: .capsule, elevation: 3, frost: 0.7)
    }

    // MARK: - Palette Picker
    private var palettePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Coastal Palettes")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(selectedPalette.ink)

            HStack(spacing: 12) {
                ForEach(SeaGlassPalette.all) { p in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedPalette = p
                        }
                    }) {
                        Circle()
                            .fill(p.body)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Circle()
                                    .strokeBorder(
                                        selectedPalette.name == p.name ? p.ink : p.edge,
                                        lineWidth: selectedPalette.name == p.name ? 2.5 : 1
                                    )
                            }
                            .shadow(color: p.halo, radius: 4, y: 2)
                    }
                }
            }
        }
    }

    // MARK: - Shape Picker
    private var shapePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Continuous Geometry")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(selectedPalette.ink)

            Picker("Shape", selection: $selectedShapeIndex) {
                ForEach(0..<shapes.count, id: \.self) { idx in
                    Text(shapes[idx].name).tag(idx)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Sliders
    private var controlsCard: some View {
        SeaGlassSurface(palette: selectedPalette, shape: .rounded(20), elevation: 4, frost: 0.5) {
            VStack(spacing: 16) {
                // Elevation Slider
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Elevation & Caustic Pool")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                        Text(String(format: "%.1f pt", elevation))
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(selectedPalette.ink)

                    Slider(value: $elevation, in: 0...18, step: 0.5)
                        .tint(selectedPalette.accent)
                }

                // Frost Slider
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Frost & Micro-Grain Depth")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                        Text(String(format: "%d%%", Int(frost * 100)))
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(selectedPalette.ink)

                    Slider(value: $frost, in: 0.1...1.0, step: 0.05)
                        .tint(selectedPalette.accent)
                }
            }
            .padding(18)
        }
    }

    // MARK: - Buttons Demo
    private var buttonsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tactile Buttons & Haptics")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(selectedPalette.ink)

            HStack(spacing: 14) {
                SeaGlassButton(palette: selectedPalette, shape: .capsule, elevation: 6, action: {
                    pressCount += 1
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "hand.tap.fill")
                        Text("Depress (\(pressCount))")
                    }
                }

                SeaGlassButton(palette: .rose, shape: .disc, elevation: 6, action: {
                    pressCount += 1
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(SeaGlassPalette.rose.ink)
                        .frame(width: 20, height: 20)
                }

                SeaGlassButton(palette: .mint, shape: .rounded(14), elevation: 6, action: {
                    pressCount += 1
                }) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(SeaGlassPalette.mint.ink)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}
