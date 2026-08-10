import SwiftUI

/// Parametric technical vector diagram for Round Bars, Square Bars, Flats, and Plates.
public struct BarDiagramView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let pad: CGFloat = 36

            let centerX = w / 2.0
            let centerY = h / 2.0

            // Coordinate axes
            var axisPath = Path()
            axisPath.move(to: CGPoint(x: pad / 2, y: centerY))
            axisPath.addLine(to: CGPoint(x: w - pad / 2, y: centerY))
            axisPath.move(to: CGPoint(x: centerX, y: pad / 2))
            axisPath.addLine(to: CGPoint(x: centerX, y: h - pad / 2))

            context.stroke(
                axisPath,
                with: .color(Color.cyan.opacity(0.4)),
                style: StrokeStyle(lineWidth: 1, dash: [4, 3])
            )

            switch section.family {
            case .roundBars:
                let dia = CGFloat(section.dimensions.diameter_d_mm ?? 20)
                let radius = min((w - 2 * pad) / 2.0, (h - 2 * pad) / 2.0) * 0.7
                let circleRect = CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2)

                context.fill(Path(ellipseIn: circleRect), with: .color(Color.accentColor.opacity(0.18)))
                context.stroke(Path(ellipseIn: circleRect), with: .color(Color.primary), lineWidth: 2)

                drawText(context: context, text: "Ø = \(Int(dia)) mm", at: CGPoint(x: centerX, y: circleRect.minY - 14), color: .primary)

            case .squareBars:
                let side = CGFloat(section.dimensions.side_s_mm ?? 25)
                let drawSide = min(w - 2 * pad, h - 2 * pad) * 0.7
                let rect = CGRect(x: centerX - drawSide / 2, y: centerY - drawSide / 2, width: drawSide, height: drawSide)

                context.fill(Path(rect), with: .color(Color.accentColor.opacity(0.18)))
                context.stroke(Path(rect), with: .color(Color.primary), lineWidth: 2)

                drawText(context: context, text: "\(Int(side)) x \(Int(side)) mm", at: CGPoint(x: centerX, y: rect.minY - 14), color: .primary)

            case .flats, .hrPlates:
                let widthB = CGFloat(section.dimensions.width_b_mm ?? 100)
                let thicknessT = CGFloat(section.dimensions.thickness_t_mm ?? 10)
                let drawW = (w - 2 * pad) * 0.8
                let drawH = max(drawW * (thicknessT / max(widthB, 20)), 16.0)
                let rect = CGRect(x: centerX - drawW / 2, y: centerY - drawH / 2, width: drawW, height: drawH)

                context.fill(Path(rect), with: .color(Color.accentColor.opacity(0.18)))
                context.stroke(Path(rect), with: .color(Color.primary), lineWidth: 2)

                drawText(context: context, text: "B = \(Int(widthB)) mm", at: CGPoint(x: centerX, y: rect.minY - 14), color: .primary)
                drawText(context: context, text: "t = \(Int(thicknessT)) mm", at: CGPoint(x: rect.maxX + 24, y: centerY), color: .orange)

            default:
                break
            }

            // Axis labels
            drawText(context: context, text: "X", at: CGPoint(x: w - pad + 8, y: centerY), color: .cyan)
            drawText(context: context, text: "X", at: CGPoint(x: pad - 12, y: centerY), color: .cyan)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: pad - 12), color: .cyan)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: h - pad + 12), color: .cyan)
        }
    }

    private func drawText(context: GraphicsContext, text: String, at pt: CGPoint, color: Color, size: CGFloat = 11) {
        let textResolved = Text(text).font(.system(size: size, weight: .semibold, design: .monospaced)).foregroundColor(color)
        context.draw(textResolved, at: pt, anchor: .center)
    }
}

/// Parametric technical vector diagram for Tee sections (ISNT, ISHT, ISST).
public struct TeeDiagramView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let pad: CGFloat = 36

            let depthH = CGFloat(section.dimensions.depth_h_mm ?? 100)
            let widthB = CGFloat(section.dimensions.width_b_mm ?? 100)
            let tw = CGFloat(section.dimensions.webThickness_tw_mm ?? 6)
            let tf = CGFloat(section.dimensions.flangeThickness_tf_mm ?? 8)

            let availW = w - 2 * pad
            let availH = h - 2 * pad
            let scale = min(availW / max(widthB, 80), availH / max(depthH, 80)) * 0.8

            let drawH = depthH * scale
            let drawB = widthB * scale
            let drawTw = max(tw * scale, 5.0)
            let drawTf = max(tf * scale, 6.0)

            let centerX = w / 2.0
            let centerY = h / 2.0

            let leftX = centerX - drawB / 2.0
            let rightX = centerX + drawB / 2.0
            let topY = centerY - drawH / 2.0
            let bottomY = centerY + drawH / 2.0

            let webLeftX = centerX - drawTw / 2.0
            let webRightX = centerX + drawTw / 2.0

            // Coordinate axes
            var axisPath = Path()
            axisPath.move(to: CGPoint(x: pad / 2, y: centerY))
            axisPath.addLine(to: CGPoint(x: w - pad / 2, y: centerY))
            axisPath.move(to: CGPoint(x: centerX, y: pad / 2))
            axisPath.addLine(to: CGPoint(x: centerX, y: h - pad / 2))

            context.stroke(
                axisPath,
                with: .color(Color.cyan.opacity(0.4)),
                style: StrokeStyle(lineWidth: 1, dash: [4, 3])
            )

            // T-Section Profile
            var profile = Path()
            profile.move(to: CGPoint(x: leftX, y: topY))
            profile.addLine(to: CGPoint(x: rightX, y: topY))
            profile.addLine(to: CGPoint(x: rightX, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: webRightX, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: webRightX, y: bottomY))
            profile.addLine(to: CGPoint(x: webLeftX, y: bottomY))
            profile.addLine(to: CGPoint(x: webLeftX, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: leftX, y: topY + drawTf))
            profile.closeSubpath()

            context.fill(profile, with: .color(Color.accentColor.opacity(0.18)))
            context.stroke(profile, with: .color(Color.primary), lineWidth: 2)

            // Dimension callouts
            drawText(context: context, text: "bf = \(Int(widthB)) mm", at: CGPoint(x: centerX, y: topY - 14), color: .primary)
            drawText(context: context, text: "h = \(Int(depthH)) mm", at: CGPoint(x: leftX - 16, y: centerY), color: .primary)
            drawText(context: context, text: "tw = \(String(format: "%.1f", tw)) mm", at: CGPoint(x: webRightX + 24, y: bottomY - 10), color: .orange)

            // Axis labels
            drawText(context: context, text: "X", at: CGPoint(x: w - pad + 8, y: centerY), color: .cyan)
            drawText(context: context, text: "X", at: CGPoint(x: pad - 12, y: centerY), color: .cyan)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: pad - 12), color: .cyan)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: h - pad + 12), color: .cyan)
        }
    }

    private func drawText(context: GraphicsContext, text: String, at pt: CGPoint, color: Color, size: CGFloat = 11) {
        let textResolved = Text(text).font(.system(size: size, weight: .semibold, design: .monospaced)).foregroundColor(color)
        context.draw(textResolved, at: pt, anchor: .center)
    }
}
