import SwiftUI

/// Container view for technical engineering diagrams with interactive grid, pinch-to-zoom, pan gestures, and CAD drafting blueprint aesthetic.
public struct DiagramCanvasContainer: View {
    public let section: SteelSection

    @State private var currentZoom: CGFloat = 1.0
    @State private var finalZoom: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero
    @State private var finalOffset: CGSize = .zero

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            // Drafting Grid Background
            BlueprintGridBackground()

            // Diagram Vector Shape with Scale & Pan
            Group {
                switch section.family {
                case .equalAngles, .unequalAngles:
                    AngleDiagramView(section: section)
                case .regularBeams, .heavyBeams:
                    BeamDiagramView(section: section)
                case .slopingChannels, .parallelChannels:
                    ChannelDiagramView(section: section)
                case .pipes:
                    PipeDiagramView(section: section)
                case .squareTubes, .rectangularTubes:
                    HollowSectionDiagramView(section: section)
                case .roundBars, .squareBars, .flats, .hrPlates:
                    BarDiagramView(section: section)
                case .tees:
                    TeeDiagramView(section: section)
                }
            }
            .padding(10)
            .scaleEffect(finalZoom * currentZoom)
            .offset(x: finalOffset.width + currentOffset.width, y: finalOffset.height + currentOffset.height)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in currentZoom = value }
                    .onEnded { value in
                        finalZoom = min(max(finalZoom * value, 0.8), 3.0)
                        currentZoom = 1.0
                    }
            )
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in currentOffset = value.translation }
                    .onEnded { value in
                        finalOffset.width += value.translation.width
                        finalOffset.height += value.translation.height
                        currentOffset = .zero
                    }
            )

            // Canvas Tools Overlay (Zoom Reset & CAD Badge)
            HStack(spacing: 8) {
                if finalZoom != 1.0 || finalOffset != .zero {
                    Button {
                        withAnimation(.spring()) {
                            finalZoom = 1.0
                            currentZoom = 1.0
                            finalOffset = .zero
                            currentOffset = .zero
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.65))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    }
                }

                Text("CAD VECTOR")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(ColorTokens.badgeBackground)
                    .foregroundColor(.secondary)
                    .cornerRadius(4)
            }
            .padding(10)
        }
        .frame(height: 280)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .clipped()
    }
}
