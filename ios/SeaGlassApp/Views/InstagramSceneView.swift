//
//  InstagramSceneView.swift
//  SeaGlassApp
//
//  Instagram feed and stories redesign with Liquid Sea Glass.
//

import SwiftUI

public struct InstagramSceneView: View {
    @State private var likedPosts: Set<Int> = [1]
    @State private var bookmarkedPosts: Set<Int> = []
    @State private var selectedTab: Int = 0

    struct Story: Identifiable {
        let id: Int
        let name: String
        let palette: SeaGlassPalette
        let isUser: Bool
        let symbol: String
    }

    struct Post: Identifiable {
        let id: Int
        let author: String
        let location: String
        let palette: SeaGlassPalette
        let caption: String
        let likes: Int
        let timeAgo: String
        let gradientColors: [Color]
        let tag: String
    }

    private let stories: [Story] = [
        Story(id: 0, name: "Your Story", palette: .lagoon, isUser: true, symbol: "person.crop.circle"),
        Story(id: 1, name: "kai_coastal", palette: .mint, isUser: false, symbol: "water.waves"),
        Story(id: 2, name: "sora_glass", palette: .rose, isUser: false, symbol: "sparkles"),
        Story(id: 3, name: "amalfi.tide", palette: .amber, isUser: false, symbol: "sun.haze.fill"),
        Story(id: 4, name: "lumina.drift", palette: .lilac, isUser: false, symbol: "moon.stars.fill"),
        Story(id: 5, name: "pebble_bay", palette: .lagoon, isUser: false, symbol: "leaf.fill")
    ]

    private let posts: [Post] = [
        Post(
            id: 1,
            author: "elena_coastal",
            location: "Big Sur Sanctuary, California",
            palette: .lagoon,
            caption: "Morning light catching the tumbled edges of the ocean glass. Every curve smoothed by thousands of tides 🌊✨",
            likes: 1248,
            timeAgo: "23m ago",
            gradientColors: [
                Color(red: 0.20, green: 0.45, blue: 0.65),
                Color(red: 0.45, green: 0.70, blue: 0.82),
                Color(red: 0.80, green: 0.90, blue: 0.95)
            ],
            tag: "Lagoon Volumetric #04"
        ),
        Post(
            id: 2,
            author: "atelier_moro",
            location: "Amalfi Coastline",
            palette: .rose,
            caption: "Soft blush tones and continuous squircle curvature. Designed with the new Sea Glass liquid optics for iOS.",
            likes: 3419,
            timeAgo: "2h ago",
            gradientColors: [
                Color(red: 0.85, green: 0.40, blue: 0.52),
                Color(red: 0.95, green: 0.68, blue: 0.72),
                Color(red: 0.98, green: 0.88, blue: 0.85)
            ],
            tag: "Rose Quartz Tumble"
        ),
        Post(
            id: 3,
            author: "sanctuary_labs",
            location: "Kyoto Tea Pavilion",
            palette: .mint,
            caption: "Living with tactile interfaces. The ground halo dynamically refracts environmental light.",
            likes: 892,
            timeAgo: "5h ago",
            gradientColors: [
                Color(red: 0.18, green: 0.45, blue: 0.38),
                Color(red: 0.48, green: 0.75, blue: 0.65),
                Color(red: 0.82, green: 0.94, blue: 0.88)
            ],
            tag: "Coastal Mint Halo"
        )
    ]

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Ambient Coastal Backdrop
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.96, blue: 0.98),
                    Color(red: 0.88, green: 0.92, blue: 0.96),
                    Color(red: 0.93, green: 0.95, blue: 0.97)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header Bar
                    headerBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    // Stories Row
                    storiesRow
                        .padding(.top, 4)

                    // Feed Posts
                    ForEach(posts) { post in
                        postCard(for: post)
                            .padding(.horizontal, 16)
                    }

                    Spacer()
                        .frame(height: 100) // Padding for floating dock
                }
            }

            // Floating Sea Glass Bottom Navigation Dock
            floatingDock
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
        }
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(SeaGlassPalette.lagoon.accent)
                Text("Instagram")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(SeaGlassPalette.lagoon.ink)
            }

            Spacer()

            HStack(spacing: 12) {
                SeaGlassButton(palette: .lagoon, shape: .disc, elevation: 5, action: {}) {
                    Image(systemName: "heart")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 14, height: 14)
                }

                SeaGlassButton(palette: .lagoon, shape: .disc, elevation: 5, action: {}) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 14, height: 14)
                }
            }
        }
    }

    // MARK: - Stories Row
    private var storiesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(stories) { story in
                    VStack(spacing: 6) {
                        ZStack {
                            // Sea Glass story ring
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [story.palette.edge, story.palette.accent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2.8
                                )
                                .frame(width: 68, height: 68)
                                .shadow(color: story.palette.halo, radius: 6, y: 3)

                            // Inner circle
                            Circle()
                                .fill(story.palette.body.opacity(0.35))
                                .frame(width: 58, height: 58)
                                .overlay {
                                    Image(systemName: story.symbol)
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(story.palette.ink)
                                }

                            if story.isUser {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(SeaGlassPalette.lagoon.accent)
                                            .background(Circle().fill(.white))
                                    }
                                }
                                .frame(width: 68, height: 68)
                            }
                        }

                        Text(story.name)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(SeaGlassPalette.lagoon.ink.opacity(0.85))
                            .frame(width: 70)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Post Card
    private func postCard(for post: Post) -> some View {
        let isLiked = likedPosts.contains(post.id)
        let isSaved = bookmarkedPosts.contains(post.id)

        return SeaGlassSurface(palette: post.palette, shape: .rounded(26), elevation: 8, frost: 0.6) {
            VStack(alignment: .leading, spacing: 14) {
                // Post Author Header
                HStack(spacing: 10) {
                    Circle()
                        .fill(post.palette.accent.opacity(0.2))
                        .frame(width: 38, height: 38)
                        .overlay {
                            Text(String(post.author.prefix(1)).uppercased())
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(post.palette.ink)
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.author)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(post.palette.ink)

                        Text(post.location)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(post.palette.ink.opacity(0.7))
                    }

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(post.palette.ink.opacity(0.6))
                    }
                }

                // Media Presentation Area
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: post.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 280)
                        .overlay {
                            VStack {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 42, weight: .light))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Liquid Frosted Glass")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }

                    // Floating Tag Badge
                    Text(post.tag)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .seaGlass(palette: post.palette, shape: .capsule, elevation: 4, frost: 0.75)
                        .padding(12)
                }

                // Action Bar
                HStack(spacing: 12) {
                    Button(action: {
                        if isLiked {
                            likedPosts.remove(post.id)
                        } else {
                            likedPosts.insert(post.id)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? Color.red : post.palette.ink)
                            Text("\(post.likes + (isLiked ? 1 : 0))")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                        }
                    }

                    Button(action: {}) {
                        Image(systemName: "bubble.right")
                    }

                    Button(action: {}) {
                        Image(systemName: "paperplane")
                    }

                    Spacer()

                    Button(action: {
                        if isSaved {
                            bookmarkedPosts.remove(post.id)
                        } else {
                            bookmarkedPosts.insert(post.id)
                        }
                    }) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isSaved ? post.palette.accent : post.palette.ink)
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(post.palette.ink)
                .padding(.top, 2)

                // Caption
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.caption)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(post.palette.ink.opacity(0.9))
                        .lineSpacing(3)

                    Text(post.timeAgo)
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(post.palette.ink.opacity(0.55))
                }
            }
            .padding(16)
        }
    }

    // MARK: - Floating Liquid Glass Dock
    private var floatingDock: some View {
        HStack(spacing: 24) {
            dockItem(systemName: "house.fill", index: 0)
            dockItem(systemName: "magnifyingglass", index: 1)
            dockItem(systemName: "plus.app", index: 2)
            dockItem(systemName: "play.square.stack", index: 3)
            dockItem(systemName: "person.crop.circle", index: 4)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .seaGlass(palette: .lagoon, shape: .capsule, elevation: 12, frost: 0.7)
    }

    private func dockItem(systemName: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            Image(systemName: systemName)
                .font(.system(size: 19, weight: selectedTab == index ? .bold : .regular))
                .foregroundColor(selectedTab == index ? SeaGlassPalette.lagoon.accent : SeaGlassPalette.lagoon.ink.opacity(0.6))
                .scaleEffect(selectedTab == index ? 1.15 : 1.0)
                .animation(.spring(response: 0.22, dampingFraction: 0.65), value: selectedTab)
        }
    }
}
