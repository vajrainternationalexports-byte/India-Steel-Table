import SwiftUI

/// Screen 1: Home Category List matching Android IS Steel Table v1.4.3 Screenshot 1, 4, 7.
public struct HomeCategoryListView: View {
    public let onSelectCategory: (SectionFamily) -> Void

    // 13 Exact Category Titles in verbatim Android display order
    public static let categoryList: [(title: String, family: SectionFamily)] = [
        ("EQUAL ANGLES", .equalAngles),
        ("UNEQUAL ANGLES", .unequalAngles),
        ("REGULAR BEAMS", .regularBeams),
        ("HEAVY WEIGHT BEAMS", .heavyBeams),
        ("SLOPING FLANGE CHANNELS", .slopingChannels),
        ("PARALLEL FLANGE CHANNELS", .parallelChannels),
        ("PIPES", .pipes),
        ("RECTANGULAR TUBES", .rectangularTubes),
        ("SQUARE TUBES", .squareTubes),
        ("SQUARE BARS", .squareBars),
        ("ROUND BARS", .roundBars),
        ("FLATS", .flats),
        ("HR PLATES", .hrPlates)
    ]

    public init(onSelectCategory: @escaping (SectionFamily) -> Void) {
        self.onSelectCategory = onSelectCategory
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(Self.categoryList, id: \.title) { item in
                    Button {
                        onSelectCategory(item.family)
                    } label: {
                        HStack {
                            Text(item.title)
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(.white)
                                .letterSpacing(0.4)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.31, green: 0.33, blue: 0.35), Color(red: 0.24, green: 0.26, blue: 0.28)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(red: 0.37, green: 0.39, blue: 0.42), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color(red: 0.13, green: 0.14, blue: 0.16))
        .navigationTitle("IS Steel Table")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("v.1.4.3")
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "bookmark")
                    .foregroundColor(.white)
            }
        }
    }
}
