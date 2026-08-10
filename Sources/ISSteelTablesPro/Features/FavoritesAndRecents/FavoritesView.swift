import SwiftUI

/// Screen displaying starred favorite steel sections and recently viewed history with search and management.
public struct FavoritesView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var selectedTab: Int = 0
    @State private var searchText: String = ""

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Picker (Favorites vs Recents)
                Picker("View", selection: $selectedTab) {
                    Text("Favorites (\(environment.favoriteIds.count))").tag(0)
                    Text("Recently Viewed (\(environment.recentIds.count))").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                if selectedTab == 0 {
                    favoritesList
                } else {
                    recentsList
                }
            }
            .navigationTitle(selectedTab == 0 ? "Starred Sections" : "Recently Viewed")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search in favorites...")
            .toolbar {
                if selectedTab == 1 && !environment.recentIds.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            Task { await environment.favoritesRepository.clearRecentlyViewed() }
                            environment.recentIds.removeAll()
                        }
                    }
                }
            }
            .background(ColorTokens.viewBackground)
        }
    }

    private var favoritesList: some View {
        let favSections = environment.allSections.filter { environment.favoriteIds.contains($0.id) }
        let filtered = searchText.isEmpty ? favSections : SectionSearchIndexer(sections: favSections).search(query: searchText)

        return Group {
            if filtered.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(searchText.isEmpty ? "No Starred Sections" : "No Matches")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Tap the star icon on any section detail screen to save it for quick offline access.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filtered) { sec in
                    NavigationLink(destination: SectionDetailView(section: sec)) {
                        SectionRowCard(
                            section: sec,
                            isFavorite: true,
                            onToggleFavorite: {
                                Task { await environment.toggleFavorite(sectionId: sec.id) }
                            }
                        )
                    }
                }
            }
        }
    }

    private var recentsList: some View {
        let recentSections = environment.recentIds.compactMap { id in
            environment.allSections.first { $0.id == id }
        }
        let filtered = searchText.isEmpty ? recentSections : SectionSearchIndexer(sections: recentSections).search(query: searchText)

        return Group {
            if filtered.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("No Recently Viewed Sections")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Sections you inspect will automatically appear here for rapid re-reference.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filtered) { sec in
                    NavigationLink(destination: SectionDetailView(section: sec)) {
                        SectionRowCard(
                            section: sec,
                            isFavorite: environment.isFavorite(sectionId: sec.id),
                            onToggleFavorite: {
                                Task { await environment.toggleFavorite(sectionId: sec.id) }
                            }
                        )
                    }
                }
            }
        }
    }
}
