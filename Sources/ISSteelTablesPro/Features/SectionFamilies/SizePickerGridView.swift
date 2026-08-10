import SwiftUI

/// Screen 3: 2-Column Size Grid Picker matching Android IS Steel Table v1.4.3 Screenshots 3, 6, 8.
public struct SizePickerGridView: View {
    @EnvironmentObject private var environment: AppEnvironment

    public let family: SectionFamily
    public let currentSectionId: String
    public let onSelectSection: (SteelSection) -> Void

    private let gridColumns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    public init(
        family: SectionFamily,
        currentSectionId: String,
        onSelectSection: @escaping (SteelSection) -> Void
    ) {
        self.family = family
        self.currentSectionId = currentSectionId
        self.onSelectSection = onSelectSection
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Sub-Header Bar (Upward Triangle ▲ + Designation)
            let currentSec = environment.allSections.first(where: { $0.id == currentSectionId })
            let designationText = currentSec != nil ? cleanDesignation(currentSec!) : family.rawValue

            HStack {
                Image(systemName: "triangle.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                Spacer()
                Text(designationText)
                    .font(.system(size: 17, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.33, green: 0.34, blue: 0.37), Color(red: 0.26, green: 0.27, blue: 0.29)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(red: 0.39, green: 0.40, blue: 0.44), lineWidth: 1)
            )
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 6)

            // 2-Column Grid
            ScrollView {
                let sameFamilySections = environment.allSections.filter { $0.family == family }

                LazyVGrid(columns: gridColumns, spacing: 8) {
                    ForEach(sameFamilySections) { sec in
                        Button {
                            onSelectSection(sec)
                        } label: {
                            Text(cleanDesignation(sec))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [Color(red: 0.30, green: 0.32, blue: 0.35), Color(red: 0.23, green: 0.25, blue: 0.27)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(red: 0.36, green: 0.38, blue: 0.41), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
        }
        .background(Color(red: 0.13, green: 0.14, blue: 0.16))
        .navigationTitle(family.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func cleanDesignation(_ s: SteelSection) -> String {
        var d = s.designation
        d = d.replacingOccurrences(of: "^ISA\\s+", with: "", options: .regularExpression)
        d = d.replacingOccurrences(of: "^FLAT\\s+", with: "", options: .regularExpression)
        d = d.replacingOccurrences(of: "^PLATE\\s+", with: "", options: .regularExpression)
        return d
    }
}
