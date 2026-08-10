import SwiftUI

/// Explorer screen for a specific Section Family (e.g. Beams, Channels, Angles) with series filters, search, sort, and table mode toggle.
public struct SectionFamilyListView: View {
    public let family: SectionFamily
    @EnvironmentObject private var environment: AppEnvironment

    @State private var searchText: String = ""
    @State private var selectedSeries: String = "All"
    @State private var sortOption: SortOption = .natural
    @State private var sortAscending: Bool = true
    @State private var isTableViewMode: Bool = false
    @State private var isFilterSheetPresented: Bool = false

    // Range Filters
    @State private var minMass: Double? = nil
    @State private var maxMass: Double? = nil
    @State private var minDepth: Double? = nil
    @State private var maxDepth: Double? = nil

    public enum SortOption: String, CaseIterable, Identifiable {
        case natural = "Standard Order"
        case designation = "Designation"
        case mass = "Mass (kg/m)"
        case area = "Area (cm²)"
        case depth = "Depth / Height"

        public var id: String { rawValue }
    }

    public init(family: SectionFamily) {
        self.family = family
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Series Segmented Filter Bar if applicable
            seriesFilterBar

            // Active Filters Summary Bar
            if hasActiveFilters {
                activeFiltersBar
            }

            // Content List or Table Grid
            if isTableViewMode {
                familyTableGrid
            } else {
                familyCardsList
            }
        }
        .navigationTitle(family.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search within \(family.shortTitle)...")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    // Table / Card mode toggle
                    Button {
                        isTableViewMode.toggle()
                    } label: {
                        Image(systemName: isTableViewMode ? "list.bullet" : "tablecells")
                    }

                    // Sort menu
                    Menu {
                        Section("Sort By") {
                            ForEach(SortOption.allCases) { opt in
                                Button {
                                    if sortOption == opt {
                                        sortAscending.toggle()
                                    } else {
                                        sortOption = opt
                                        sortAscending = true
                                    }
                                } label: {
                                    HStack {
                                        Text(opt.rawValue)
                                        if sortOption == opt {
                                            Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }

                    // Filter sheet button
                    Button {
                        isFilterSheetPresented = true
                    } label: {
                        Image(systemName: hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $isFilterSheetPresented) {
            SectionFilterSheet(
                minMass: $minMass,
                maxMass: $maxMass,
                minDepth: $minDepth,
                maxDepth: $maxDepth
            )
        }
        .background(ColorTokens.viewBackground)
    }

    // MARK: - Series Filter Bar
    @ViewBuilder
    private var seriesFilterBar: some View {
        let allSectionsInFamily = environment.allSections.filter { $0.family == family }
        let distinctSeries = Array(Set(allSectionsInFamily.map { $0.series }.filter { !$0.isEmpty })).sorted()

        if distinctSeries.count > 1 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    SeriesFilterChip(
                        title: "All (\(allSectionsInFamily.count))",
                        isSelected: selectedSeries == "All",
                        action: { selectedSeries = "All" }
                    )

                    ForEach(distinctSeries, id: \.self) { ser in
                        let count = allSectionsInFamily.filter { $0.series == ser }.count
                        SeriesFilterChip(
                            title: "\(ser) (\(count))",
                            isSelected: selectedSeries == ser,
                            action: { selectedSeries = ser }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color(uiColor: .systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.primary.opacity(0.08)),
                alignment: .bottom
            )
        }
    }

    // MARK: - Active Filters Bar
    private var activeFiltersBar: some View {
        HStack {
            Text("Filtered Results (\(filteredSections.count))")
                .font(.caption.bold())
                .foregroundColor(.secondary)

            Spacer()

            Button("Clear Filters") {
                minMass = nil
                maxMass = nil
                minDepth = nil
                maxDepth = nil
                selectedSeries = "All"
            }
            .font(.caption.bold())
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(ColorTokens.cardBackground)
    }

    private var hasActiveFilters: Bool {
        minMass != nil || maxMass != nil || minDepth != nil || maxDepth != nil || selectedSeries != "All"
    }

    // MARK: - Filtered & Sorted Sections
    private var filteredSections: [SteelSection] {
        var items = environment.allSections.filter { $0.family == family }

        // Series Filter
        if selectedSeries != "All" {
            items = items.filter { $0.series == selectedSeries }
        }

        // Search Filter
        if !searchText.isEmpty {
            let indexer = SectionSearchIndexer(sections: items)
            items = indexer.search(query: searchText, family: family)
        }

        // Range Filters
        if let minM = minMass {
            items = items.filter { $0.massPerMetre >= minM }
        }
        if let maxM = maxMass {
            items = items.filter { $0.massPerMetre <= maxM }
        }
        if let minD = minDepth {
            items = items.filter { ($0.dimensions.primaryDepth ?? 0) >= minD }
        }
        if let maxD = maxDepth {
            items = items.filter { ($0.dimensions.primaryDepth ?? 0) <= maxD }
        }

        // Sorting
        switch sortOption {
        case .natural:
            return sortAscending ? items : items.reversed()
        case .designation:
            return items.sorted {
                sortAscending ? $0.designation.localizedStandardCompare($1.designation) == .orderedAscending
                              : $0.designation.localizedStandardCompare($1.designation) == .orderedDescending
            }
        case .mass:
            return items.sorted {
                sortAscending ? $0.massPerMetre < $1.massPerMetre : $0.massPerMetre > $1.massPerMetre
            }
        case .area:
            return items.sorted {
                sortAscending ? $0.area < $1.area : $0.area > $1.area
            }
        case .depth:
            return items.sorted {
                let d0 = $0.dimensions.primaryDepth ?? 0
                let d1 = $1.dimensions.primaryDepth ?? 0
                return sortAscending ? d0 < d1 : d0 > d1
            }
        }
    }

    // MARK: - Cards List Mode
    private var familyCardsList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(filteredSections) { sec in
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
            .padding(16)
        }
    }

    // MARK: - High Density Table Mode
    private var familyTableGrid: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                // Table Header
                HStack(spacing: 0) {
                    Text("Designation")
                        .font(.caption.bold().monospaced())
                        .frame(width: 140, alignment: .leading)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)

                    Text("W (kg/m)")
                        .font(.caption.bold().monospaced())
                        .frame(width: 80, alignment: .trailing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)

                    Text("A (cm²)")
                        .font(.caption.bold().monospaced())
                        .frame(width: 80, alignment: .trailing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)

                    Text("Depth (mm)")
                        .font(.caption.bold().monospaced())
                        .frame(width: 80, alignment: .trailing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)

                    Text("Width (mm)")
                        .font(.caption.bold().monospaced())
                        .frame(width: 80, alignment: .trailing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)

                    Text("Ix (cm⁴)")
                        .font(.caption.bold().monospaced())
                        .frame(width: 90, alignment: .trailing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)

                    Text("Iy (cm⁴)")
                        .font(.caption.bold().monospaced())
                        .frame(width: 90, alignment: .trailing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(ColorTokens.badgeBackground)
                }

                Divider()

                // Table Rows
                ForEach(Array(filteredSections.enumerated()), id: \.element.id) { (idx, sec) in
                    NavigationLink(destination: SectionDetailView(section: sec)) {
                        HStack(spacing: 0) {
                            Text(sec.designation)
                                .font(.caption.monospaced().bold())
                                .foregroundColor(.primary)
                                .frame(width: 140, alignment: .leading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(String(format: "%.1f", sec.massPerMetre))
                                .font(.caption.monospaced())
                                .foregroundColor(.primary)
                                .frame(width: 80, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(String(format: "%.1f", sec.area))
                                .font(.caption.monospaced())
                                .foregroundColor(.primary)
                                .frame(width: 80, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.dimensions.primaryDepth != nil ? "\(Int(sec.dimensions.primaryDepth!))" : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: 80, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.dimensions.primaryWidth != nil ? "\(Int(sec.dimensions.primaryWidth!))" : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: 80, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.structural.ixx_cm4 != nil ? String(format: "%.1f", sec.structural.ixx_cm4!) : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: 90, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.structural.iyy_cm4 != nil ? String(format: "%.1f", sec.structural.iyy_cm4!) : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: 90, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                        }
                        .background(idx % 2 == 0 ? ColorTokens.cardBackground : ColorTokens.cardBackground.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
        }
    }
}

/// Filter chip for section series.
struct SeriesFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold().monospaced())
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : ColorTokens.badgeBackground)
                .cornerRadius(8)
        }
    }
}

/// Sheet for configuring range filters (Mass, Depth).
public struct SectionFilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var minMass: Double?
    @Binding var maxMass: Double?
    @Binding var minDepth: Double?
    @Binding var maxDepth: Double?

    @State private var minMassText: String = ""
    @State private var maxMassText: String = ""
    @State private var minDepthText: String = ""
    @State private var maxDepthText: String = ""

    public init(
        minMass: Binding<Double?>,
        maxMass: Binding<Double?>,
        minDepth: Binding<Double?>,
        maxDepth: Binding<Double?>
    ) {
        self._minMass = minMass
        self._maxMass = maxMass
        self._minDepth = minDepth
        self._maxDepth = maxDepth
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Mass Range (kg/m)") {
                    HStack {
                        TextField("Min kg/m", text: $minMassText)
                            .keyboardType(.decimalPad)
                        Divider()
                        TextField("Max kg/m", text: $maxMassText)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Depth / Height Range (mm)") {
                    HStack {
                        TextField("Min mm", text: $minDepthText)
                            .keyboardType(.decimalPad)
                        Divider()
                        TextField("Max mm", text: $maxDepthText)
                            .keyboardType(.decimalPad)
                    }
                }

                Section {
                    Button("Reset All Filters", role: .destructive) {
                        minMass = nil
                        maxMass = nil
                        minDepth = nil
                        maxDepth = nil
                        dismiss()
                    }
                }
            }
            .navigationTitle("Filter Sections")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        minMass = Double(minMassText)
                        maxMass = Double(maxMassText)
                        minDepth = Double(minDepthText)
                        maxDepth = Double(maxDepthText)
                        dismiss()
                    }
                    .bold()
                }
            }
            .onAppear {
                if let minM = minMass { minMassText = "\(minM)" }
                if let maxM = maxMass { maxMassText = "\(maxM)" }
                if let minD = minDepth { minDepthText = "\(minD)" }
                if let maxD = maxDepth { maxDepthText = "\(maxD)" }
            }
        }
    }
}
