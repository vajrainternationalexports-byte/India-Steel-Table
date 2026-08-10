import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// All-in-One Engineering Dashboard Section Detail View:
/// Features:
/// - Floating top designation picker e.g. `[ 20 20X3 ▼ ]` opening a 2-column quick size selector
/// - Swipe left/right gestures to cycle adjacent section sizes
/// - Full CAD-style schematic diagram with zoom/pan
/// - Live integrated Real-Time Rate (₹/kg) & Weight Estimator Card directly on screen
/// - Full categorized properties list matching authentic IS standards & Android screens
public struct SectionDetailView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var currentSection: SteelSection
    @State private var isQuickSwitcherPresented: Bool = false
    @State private var isShareSheetPresented: Bool = false
    @State private var shareText: String = ""
    @State private var copiedToastMessage: String? = nil
    @State private var addedToBOMToast: Bool = false

    // Live Real-Time Estimator State
    @State private var estimatorLengthText: String = "6.0"
    @State private var estimatorQty: Int = 1
    @State private var estimatorRateText: String = "75.0"
    @State private var isEstimatorExpanded: Bool = true

    public init(section: SteelSection) {
        self._currentSection = State(initialValue: section)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Top Floating Switcher Pill & Category Subtitle
                topSwitcherHeader

                // Technical CAD Vector Blueprint Diagram Canvas
                DiagramCanvasContainer(section: currentSection)

                // Quick Action Bar (Favorite, In-Compare, Share)
                quickActionBar

                // Live Integrated Real-Time Rate (₹/kg) & Weight Estimator Card
                liveEstimatorCard

                // Categorized Structural Specifications
                let propertyGroups = SectionPropertyExtractor.extractAllProperties(
                    section: currentSection,
                    precision: environment.decimalPrecision
                )

                ForEach(PropertyCategory.allCases) { category in
                    if let items = propertyGroups[category], !items.isEmpty {
                        PropertyGroupCard(
                            category: category,
                            items: items,
                            onCopy: { item in
                                copyToClipboard(item)
                            }
                        )
                    }
                }

                // Reference Standard Notice
                standardFooter
            }
            .padding(16)
        }
        .navigationTitle(currentSection.designation)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    isQuickSwitcherPresented = true
                } label: {
                    HStack(spacing: 6) {
                        Text(currentSection.designation)
                            .font(.headline.monospaced().bold())
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.caption)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(ColorTokens.badgeBackground)
                    .cornerRadius(8)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        Task { await environment.toggleFavorite(sectionId: currentSection.id) }
                    } label: {
                        Image(systemName: environment.isFavorite(sectionId: currentSection.id) ? "star.fill" : "star")
                            .foregroundColor(environment.isFavorite(sectionId: currentSection.id) ? .yellow : .accentColor)
                    }

                    Button {
                        prepareShareText()
                        isShareSheetPresented = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        // Swipe Left/Right to cycle through adjacent sizes
        .gesture(
            DragGesture(minimumDistance: 40)
                .onEnded { value in
                    if value.translation.width < -50 {
                        // Swipe Left -> Next Section
                        navigateToAdjacentSection(next: true)
                    } else if value.translation.width > 50 {
                        // Swipe Right -> Previous Section
                        navigateToAdjacentSection(next: false)
                    }
                }
        )
        .sheet(isPresented: $isQuickSwitcherPresented) {
            QuickSectionSwitcherSheet(
                currentFamily: currentSection.family,
                currentSectionId: currentSection.id
            ) { newSec in
                self.currentSection = newSec
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [shareText])
        }
        .overlay(alignment: .bottom) {
            if let toast = copiedToastMessage {
                ToastNotification(message: toast)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 24)
            }
        }
        .task {
            await environment.recordRecentlyViewed(sectionId: currentSection.id)
        }
        .background(ColorTokens.viewBackground)
    }

    // MARK: - Top Header Switcher
    private var topSwitcherHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(currentSection.family.rawValue.uppercased())
                    .font(.caption2.monospaced().bold())
                    .foregroundColor(.accentColor)
                Text(currentSection.standard)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Quick size jump button
            Button {
                isQuickSwitcherPresented = true
            } label: {
                HStack(spacing: 4) {
                    Text("Select Size")
                        .font(.caption.bold())
                    Image(systemName: "square.grid.2x2")
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.accentColor.opacity(0.12))
                .foregroundColor(.accentColor)
                .cornerRadius(8)
            }
        }
    }

    // MARK: - Quick Action Bar
    private var quickActionBar: some View {
        HStack(spacing: 10) {
            // Compare Button
            let isComparing = environment.comparisonSections.contains(where: { $0.id == currentSection.id })
            Button {
                if isComparing {
                    environment.removeFromComparison(currentSection)
                } else {
                    environment.addToComparison(currentSection)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isComparing ? "checkmark.circle.fill" : "arrow.left.and.right.square")
                    Text(isComparing ? "In Compare" : "+ Compare")
                }
                .font(.caption.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isComparing ? Color.green.opacity(0.15) : ColorTokens.badgeBackground)
                .foregroundColor(isComparing ? .green : .primary)
                .cornerRadius(10)
            }

            // Quick Switch Prev / Next Buttons
            HStack(spacing: 6) {
                Button {
                    navigateToAdjacentSection(next: false)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.caption.bold())
                        .frame(width: 38, height: 36)
                        .background(ColorTokens.badgeBackground)
                        .cornerRadius(8)
                }

                Button {
                    navigateToAdjacentSection(next: true)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .frame(width: 38, height: 36)
                        .background(ColorTokens.badgeBackground)
                        .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - Live Real-Time Rate & Weight Estimator Card
    private var liveEstimatorCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with toggle
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(ColorTokens.engineeringOrange)
                    Text("Real-Time Weight & Price Estimator")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEstimatorExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isEstimatorExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                }
            }

            if isEstimatorExpanded {
                let lengthM = Double(estimatorLengthText) ?? 0
                let (massKg, massTonnes, weightKN) = EngineeringCalculations.calculateSectionTotalMass(
                    quantity: estimatorQty,
                    lengthMeters: lengthM,
                    massPerMetreKg: currentSection.massPerMetre
                )
                let ratePerKg = Double(estimatorRateText) ?? 0
                let totalPrice = massKg * ratePerKg

                // Inputs Grid
                VStack(spacing: 10) {
                    // Length input & Presets
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Length (in meters)")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Spacer()
                            // Stock length presets
                            HStack(spacing: 6) {
                                Button("1m") { estimatorLengthText = "1.0" }
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(estimatorLengthText == "1.0" ? Color.accentColor : ColorTokens.badgeBackground)
                                    .foregroundColor(estimatorLengthText == "1.0" ? .white : .primary)
                                    .cornerRadius(4)

                                Button("6m (Stock)") { estimatorLengthText = "6.0" }
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(estimatorLengthText == "6.0" ? Color.accentColor : ColorTokens.badgeBackground)
                                    .foregroundColor(estimatorLengthText == "6.0" ? .white : .primary)
                                    .cornerRadius(4)

                                Button("12m (Trailer)") { estimatorLengthText = "12.0" }
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(estimatorLengthText == "12.0" ? Color.accentColor : ColorTokens.badgeBackground)
                                    .foregroundColor(estimatorLengthText == "12.0" ? .white : .primary)
                                    .cornerRadius(4)
                            }
                        }

                        TextField("Length in meters", text: $estimatorLengthText)
                            .keyboardType(.decimalPad)
                            .padding(8)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(8)
                    }

                    // Quantity Stepper & Rate Input
                    HStack(spacing: 12) {
                        // Quantity
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Quantity (pcs)")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)

                            HStack {
                                Button {
                                    if estimatorQty > 1 { estimatorQty -= 1 }
                                } label: {
                                    Image(systemName: "minus")
                                        .frame(width: 28, height: 28)
                                        .background(ColorTokens.badgeBackground)
                                        .cornerRadius(6)
                                }

                                Text("\(estimatorQty)")
                                    .font(.subheadline.monospaced().bold())
                                    .frame(minWidth: 32, alignment: .center)

                                Button {
                                    estimatorQty += 1
                                } label: {
                                    Image(systemName: "plus")
                                        .frame(width: 28, height: 28)
                                        .background(ColorTokens.badgeBackground)
                                        .cornerRadius(6)
                                }
                            }
                            .padding(4)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(8)
                        }

                        // Rate (₹/kg)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Rate (in ₹/kg)")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)

                            HStack {
                                Text("₹")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                TextField("75.0", text: $estimatorRateText)
                                    .keyboardType(.decimalPad)
                            }
                            .padding(8)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(8)
                        }
                    }
                }

                Divider().padding(.vertical, 4)

                // Results Summary Row
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TOTAL WEIGHT")
                            .font(.caption2.bold().monospaced())
                            .foregroundColor(.secondary)
                        Text(String(format: "%.2f kg", massKg))
                            .font(.title3.monospaced().bold())
                            .foregroundColor(ColorTokens.blueprintBlue)
                        Text(String(format: "%.3f t • %.2f kN", massTonnes, weightKN))
                            .font(.caption2.monospaced())
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("TOTAL PRICE")
                            .font(.caption2.bold().monospaced())
                            .foregroundColor(.secondary)
                        Text(String(format: "₹%.2f", totalPrice))
                            .font(.title3.monospaced().bold())
                            .foregroundColor(.green)
                        Text("@ ₹\(estimatorRateText)/kg")
                            .font(.caption2.monospaced())
                            .foregroundColor(.secondary)
                    }
                }

                // Add to Project BOM Button
                Button {
                    let bomItem = ProjectBOMItem(
                        sectionId: currentSection.id,
                        designation: currentSection.designation,
                        family: currentSection.family,
                        massPerMetre: currentSection.massPerMetre,
                        quantity: estimatorQty,
                        lengthMeters: lengthM,
                        unitRatePerKg: ratePerKg
                    )
                    // Add to default/first project
                    var projects = environment.projectRepository as? LocalProjectRepository
                    Task {
                        var defaultProj = await environment.projectRepository.getAllProjects().first ?? SteelProject(projectName: "Take-off Estimation")
                        defaultProj.items.append(bomItem)
                        await environment.projectRepository.saveProject(defaultProj)
                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        copiedToastMessage = "Added \(bomItem.designation) to Project BOM!"
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            copiedToastMessage = nil
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add to Project BOM")
                    }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.accentColor.opacity(0.12))
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
                }
            }
        }
        .padding(14)
        .background(ColorTokens.cardBackground)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Standard Footer
    private var standardFooter: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Reference: \(currentSection.standard)")
                .font(.caption.bold())
                .foregroundColor(.secondary)
            Text("Values conform to the Bureau of Indian Standards (BIS) Handbook SP 6(1) and IS structural design standards.")
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.8))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorTokens.cardBackground)
        .cornerRadius(10)
    }

    private func navigateToAdjacentSection(next: Bool) {
        let sameFamily = environment.allSections.filter { $0.family == currentSection.family }
        guard let idx = sameFamily.firstIndex(where: { $0.id == currentSection.id }) else { return }

        let targetIdx: Int
        if next {
            targetIdx = (idx + 1) < sameFamily.count ? (idx + 1) : 0
        } else {
            targetIdx = (idx - 1) >= 0 ? (idx - 1) : (sameFamily.count - 1)
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            self.currentSection = sameFamily[targetIdx]
        }
    }

    private func copyToClipboard(_ item: PropertyDisplayItem) {
        #if canImport(UIKit)
        UIPasteboard.general.string = item.formattedFullText
        #endif
        withAnimation(.easeInOut(duration: 0.2)) {
            copiedToastMessage = "Copied: \(item.formattedFullText)"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.2)) {
                copiedToastMessage = nil
            }
        }
    }

    private func prepareShareText() {
        var text = "IS Steel Tables Pro: \(currentSection.designation)\n"
        text += "Family: \(currentSection.family.rawValue)\n"
        text += "Standard: \(currentSection.standard)\n"
        text += "Mass per metre: \(currentSection.massPerMetre) kg/m\n"
        text += "Cross-Sectional Area: \(currentSection.area) cm²\n"
        if let ix = currentSection.structural.ixx_cm4 { text += "Ixx: \(ix) cm⁴\n" }
        if let iy = currentSection.structural.iyy_cm4 { text += "Iyy: \(iy) cm⁴\n" }
        if let iu = currentSection.structural.iuMax_cm4 { text += "Iu (max): \(iu) cm⁴\n" }
        if let iv = currentSection.structural.ivMin_cm4 { text += "Iv (min): \(iv) cm⁴\n" }
        text += "\nVerified against Bureau of Indian Standards (BIS)"
        self.shareText = text
    }
}

/// 2-Column Quick Section Switcher Sheet matching Android Screenshot 3, 6, & 8.
public struct QuickSectionSwitcherSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var environment: AppEnvironment

    public let currentFamily: SectionFamily
    public let currentSectionId: String
    public let onSelect: (SteelSection) -> Void

    @State private var searchText: String = ""

    private let gridColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    public var body: some View {
        NavigationStack {
            ScrollView {
                let sectionsInFamily = environment.allSections.filter { $0.family == currentFamily }
                let filtered = searchText.isEmpty ? sectionsInFamily : SectionSearchIndexer(sections: sectionsInFamily).search(query: searchText, family: currentFamily)

                LazyVGrid(columns: gridColumns, spacing: 10) {
                    ForEach(filtered) { sec in
                        let isCurrent = sec.id == currentSectionId

                        Button {
                            onSelect(sec)
                            dismiss()
                        } label: {
                            VStack(spacing: 4) {
                                Text(sec.designation)
                                    .font(.subheadline.monospaced().bold())
                                    .foregroundColor(isCurrent ? .white : .primary)
                                    .lineLimit(1)

                                HStack(spacing: 6) {
                                    Text("\(String(format: "%.1f", sec.massPerMetre)) kg/m")
                                        .font(.caption2.monospaced())
                                        .foregroundColor(isCurrent ? .white.opacity(0.8) : .secondary)

                                    Text("•")
                                        .font(.caption2)
                                        .foregroundColor(isCurrent ? .white.opacity(0.8) : .secondary)

                                    Text("\(String(format: "%.1f", sec.area)) cm²")
                                        .font(.caption2.monospaced())
                                        .foregroundColor(isCurrent ? .white.opacity(0.8) : .secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(isCurrent ? Color.accentColor : ColorTokens.cardBackground)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isCurrent ? Color.clear : Color.primary.opacity(0.08), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Select \(currentFamily.shortTitle)")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search size...")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .background(ColorTokens.viewBackground)
        }
    }
}
