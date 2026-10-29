//
//  SanctuarySceneView.swift
//  SeaGlassApp
//
//  Sanctuary Climate Hub with tactile thermostat dial and ambient controls.
//

import SwiftUI

public struct SanctuarySceneView: View {
    @State private var temperature: Double = 21.5
    @State private var selectedMode: String = "Ocean Mist"
    @State private var isDiffuserOn: Bool = true
    @State private var isPurifierOn: Bool = true
    @State private var isChamberHeated: Bool = false

    private let modes = ["Ocean Mist", "Warm Tide", "Cool Breeze", "Night Drift"]

    public init() {}

    public var body: some View {
        ZStack {
            // Calm coastal deep gradient
            LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.94, blue: 0.96),
                    Color(red: 0.82, green: 0.90, blue: 0.94),
                    Color(red: 0.88, green: 0.93, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Title Bar
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sanctuary")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(SeaGlassPalette.mint.ink)
                            Text("Coastal Living Climate")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(SeaGlassPalette.mint.ink.opacity(0.7))
                        }

                        Spacer()

                        SeaGlassButton(palette: .mint, shape: .disc, elevation: 4, action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .frame(width: 16, height: 16)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Thermostat Dial Card
                    thermostatCard
                        .padding(.horizontal, 20)

                    // Mode Selector Capsules
                    modeSelector
                        .padding(.horizontal, 20)

                    // Environmental Sensor Pills
                    sensorRow
                        .padding(.horizontal, 20)

                    // Device Toggles
                    devicesSection
                        .padding(.horizontal, 20)

                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }

    // MARK: - Thermostat Card
    private var thermostatCard: some View {
        SeaGlassSurface(palette: .mint, shape: .rounded(30), elevation: 10, frost: 0.6) {
            VStack(spacing: 20) {
                Text("Climate Target")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(SeaGlassPalette.mint.ink.opacity(0.75))

                // Tactile Circular Dial
                ZStack {
                    // Outer transmitted halo
                    Circle()
                        .fill(SeaGlassPalette.mint.halo)
                        .frame(width: 200, height: 200)
                        .blur(radius: 16)

                    // Outer dial ring
                    Circle()
                        .stroke(SeaGlassPalette.mint.edge, lineWidth: 8)
                        .frame(width: 180, height: 180)

                    // Progress arc
                    Circle()
                        .trim(from: 0.15, to: CGFloat(min(0.85, (temperature - 16.0) / 14.0 * 0.7 + 0.15)))
                        .stroke(
                            LinearGradient(
                                colors: [SeaGlassPalette.mint.accent, SeaGlassPalette.lagoon.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(90))

                    // Center Glass Disc
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 140, height: 140)
                        .overlay {
                            Circle()
                                .strokeBorder(SeaGlassPalette.mint.edge, lineWidth: 1.5)
                        }
                        .overlay {
                            VStack(spacing: 2) {
                                Text(String(format: "%.1f°", temperature))
                                    .font(.system(size: 38, weight: .bold, design: .rounded))
                                    .foregroundColor(SeaGlassPalette.mint.ink)

                                Text("Optimal Range")
                                    .font(.system(size: 10, weight: .medium, design: .rounded))
                                    .foregroundColor(SeaGlassPalette.mint.ink.opacity(0.7))
                            }
                        }
                }
                .frame(height: 200)

                // Stepper Buttons
                HStack(spacing: 28) {
                    SeaGlassButton(palette: .mint, shape: .disc, elevation: 6, action: {
                        if temperature > 16.0 {
                            temperature -= 0.5
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 20, height: 20)
                    }

                    Text("Tumble Adjust")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(SeaGlassPalette.mint.ink.opacity(0.8))

                    SeaGlassButton(palette: .mint, shape: .disc, elevation: 6, action: {
                        if temperature < 30.0 {
                            temperature += 0.5
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(24)
        }
    }

    // MARK: - Mode Selector
    private var modeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(modes, id: \.self) { mode in
                    let isSelected = selectedMode == mode
                    Button(action: {
                        selectedMode = mode
                    }) {
                        Text(mode)
                            .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                            .foregroundColor(isSelected ? SeaGlassPalette.mint.ink : SeaGlassPalette.mint.ink.opacity(0.7))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .seaGlass(
                                palette: isSelected ? .mint : .lagoon,
                                shape: .capsule,
                                elevation: isSelected ? 6 : 2,
                                frost: isSelected ? 0.75 : 0.45
                            )
                    }
                }
            }
        }
    }

    // MARK: - Sensor Row
    private var sensorRow: some View {
        HStack(spacing: 12) {
            sensorCard(icon: "humidity.fill", title: "Humidity", value: "54%", palette: .lagoon)
            sensorCard(icon: "aqi.medium", title: "Air Purity", value: "98 AQI", palette: .mint)
            sensorCard(icon: "wind", title: "Breeze", value: "14 km/h", palette: .amber)
        }
    }

    private func sensorCard(icon: String, title: String, value: String, palette: SeaGlassPalette) -> some View {
        SeaGlassSurface(palette: palette, shape: .rounded(18), elevation: 5, frost: 0.55) {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(palette.accent)

                Text(title)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(palette.ink.opacity(0.7))

                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(palette.ink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
        }
    }

    // MARK: - Devices
    private var devicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connected Devices")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(SeaGlassPalette.mint.ink)

            VStack(spacing: 10) {
                deviceRow(
                    name: "Ocean Aroma Diffuser",
                    room: "Living Room",
                    icon: "atom",
                    isOn: $isDiffuserOn,
                    palette: .rose
                )

                deviceRow(
                    name: "HEPA Glass Filter",
                    room: "Master Bedroom",
                    icon: "air.purifier",
                    isOn: $isPurifierOn,
                    palette: .mint
                )

                deviceRow(
                    name: "Underfloor Thermal Glass",
                    room: "Tea Pavilion",
                    icon: "flame.fill",
                    isOn: $isChamberHeated,
                    palette: .amber
                )
            }
        }
    }

    private func deviceRow(
        name: String,
        room: String,
        icon: String,
        isOn: Binding<Bool>,
        palette: SeaGlassPalette
    ) -> some View {
        SeaGlassSurface(palette: palette, shape: .rounded(18), elevation: 4, frost: 0.5) {
            HStack(spacing: 14) {
                Circle()
                    .fill(palette.accent.opacity(isOn.wrappedValue ? 0.25 : 0.1))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(isOn.wrappedValue ? palette.accent : palette.ink.opacity(0.4))
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(palette.ink)

                    Text(room)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(palette.ink.opacity(0.65))
                }

                Spacer()

                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .tint(palette.accent)
            }
            .padding(14)
        }
    }
}
