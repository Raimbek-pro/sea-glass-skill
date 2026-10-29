//
//  SeaGlassApp.swift
//  SeaGlassApp
//
//  Main application entry point hosting Instagram, Sanctuary, and Showcase scenes.
//

import SwiftUI

@main
struct SeaGlassApp: App {
    init() {
        // Customize appearance
        #if canImport(UIKit)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            InstagramSceneView()
                .tabItem {
                    Label("Instagram", systemImage: "photo.stack")
                }
                .tag(0)

            SanctuarySceneView()
                .tabItem {
                    Label("Sanctuary", systemImage: "house.fill")
                }
                .tag(1)

            ShowcaseSceneView()
                .tabItem {
                    Label("Playground", systemImage: "slider.horizontal.3")
                }
                .tag(2)
        }
        .tint(SeaGlassPalette.lagoon.ink)
    }
}
