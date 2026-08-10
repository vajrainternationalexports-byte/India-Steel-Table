import SwiftUI

/// Main Home Dashboard providing instant search, 14 granular family cards, quick shortcuts, and pinned sections.
public struct HomeView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var searchQuery: String = ""

    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: 12)
    ]

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Banner
                    headerBanner

                    // Instant Search Results if active
                    if !searchQuery.isEmpty {
                        searchResultsSection
                    } else {
                        // 14 Category Grid
                        sectionFamiliesGrid

                        // Quick Tools Carousel / Shortcuts
                        quickToolsSection

                        // Common / Featured Indian Steel Sections
                        featuredSections
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationTitle("IS Steel Tables Pro")
            .searchable(text: $searchQuery, prompt: "Search e.g. ISMB 300, ISA 50x50x6, ISMC 150, 15 NB...")
            .background(ColorTokens.viewBackground)
        }
    }

    // MARK: - Header Banner
    private var headerBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("100% OFFLINE • IS 808 / 1161 / 4923 / 1732")
                        .font(.caption2.bold().monospaced())
                        .foregroundColor(.secondary)
                }

                Text("Indian Steel Section Tables")
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                Text("\(environment.allSections.count) verified structural sections across 14 standard families")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "shield.checkerboard")
                .font(.system(size: 32))
                .foregroundColor(ColorTokens.blueprintBlue.opacity(0.8))
        }
        .padding(14)
        .background(ColorTokens.cardBackground)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Section Families Grid (14 Categories)
    private var sectionFamiliesGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Standard Steel Families")
                    .font(TypographyTokens.sectionHeader)
                    .foregroundColor(.primary)
                Spacer()
                Text("14 Categories")
                    .font(.caption2.monospaced().bold())
                    .foregroundColor(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(SectionFamily.allCases) { family in
                    NavigationLink(destination: SectionFamilyListView(family: family)) {
                        FamilyGridCard(
                            family: family,
                            count: environment.allSections.filter { $0.family == family }.count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Quick Tools Section
    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Engineering Shortcuts")
                .font(TypographyTokens.sectionHeader)
                .foregroundColor(.primary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    NavigationLink(destination: CalculatorsHubView()) {
                        QuickToolCard(
                            title: "Steel Calculators",
                            subtitle: "Mass, Plate, Pipe & Bar",
                            icon: "function",
                            color: ColorTokens.blueprintBlue
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: ProjectBOMEstimatorView()) {
                        QuickToolCard(
                            title: "Project Take-off",
                            subtitle: "Bill of Materials (BOM)",
                            icon: "list.clipboard",
                            color: ColorTokens.engineeringOrange
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: CompareView()) {
                        QuickToolCard(
                            title: "Compare Sections",
                            subtitle: "\(environment.comparisonSections.count) Selected",
                            icon: "arrow.left.and.right.square",
                            color: ColorTokens.steelCyan
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Featured Sections
    private var featuredSections: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular Structural Profiles")
                .font(TypographyTokens.sectionHeader)
                .foregroundColor(.primary)

            let popularIds = [
                "beam-ismb-300",
                "channel-ismc-150",
                "isa-eq-50x50x6",
                "pipe-15-mm-nb-light",
                "rhs-50x25x2_0"
            ]
            let popular = environment.allSections.filter { popularIds.contains($0.id) }

            VStack(spacing: 10) {
                ForEach(popular) { sec in
                    NavigationLink(destination: SectionDetailView(section: sec)) {
                        SectionRowCard(
                            section: sec,
                            isFavorite: environment.isFavorite(sectionId: sec.id),
                            onToggleFavorite: {
                                Task { await environment.toggleFavorite(sectionId: sec.id) }
                            }
                        )
                        .padding(12)
                        .background(ColorTokens.cardBackground)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Search Results List
    private var searchResultsSection: some View {
        let results = SectionSearchIndexer(sections: environment.allSections).search(query: searchQuery)

        return VStack(alignment: .leading, spacing: 10) {
            Text("Search Results (\(results.count))")
                .font(.subheadline.bold())
                .foregroundColor(.secondary)

            if results.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("No steel sections matching \"\(searchQuery)\"")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Try searching e.g. ISMB 300, ISMC 150, ISA 50x50x6, 15 NB Light, RHS 50x25, Flat 3x10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
            } else {
                ForEach(results) { sec in
                    NavigationLink(destination: SectionDetailView(section: sec)) {
                        SectionRowCard(
                            section: sec,
                            isFavorite: environment.isFavorite(sectionId: sec.id),
                            onToggleFavorite: {
                                Task { await environment.toggleFavorite(sectionId: sec.id) }
                            }
                        )
                        .padding(12)
                        .background(ColorTokens.cardBackground)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
