import SwiftUI

/// Parametric CAD Vector Blueprint Technical Diagram for I-Beams (ISMB, ISJB, ISLB, ISWB, ISHB, NPB).
public struct BeamDiagramView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let pad: CGFloat = 32

            let depthH = CGFloat(section.dimensions.depth_h_mm ?? 150)
            let widthB = CGFloat(section.dimensions.width_b_mm ?? 75)
            let tw = CGFloat(section.dimensions.webThickness_tw_mm ?? 5)
            let tf = CGFloat(section.dimensions.flangeThickness_tf_mm ?? 8)

            let availW = w - 2 * pad
            let availH = h - 2 * pad
            let scale = min(availW / max(widthB, 100), availH / max(depthH, 100)) * 0.85

            let drawH = depthH * scale
            let drawB = widthB * scale
            let drawTw = max(tw * scale, 5.0)
            let drawTf = max(tf * scale, 7.0)

            let centerX = w / 2.0
            let centerY = h / 2.0

            let leftX = centerX - drawB / 2.0
            let rightX = centerX + drawB / 2.0
            let topY = centerY - drawH / 2.0
            let bottomY = centerY + drawH / 2.0

            let webLeftX = centerX - drawTw / 2.0
            let webRightX = centerX + drawTw / 2.0

            // Neutral Coordinate Axes (Y-Y vertical, Z-Z horizontal)
            var axisPath = Path()
            axisPath.move(to: CGPoint(x: pad / 2, y: centerY))
            axisPath.addLine(to: CGPoint(x: w - pad / 2, y: centerY))
            axisPath.move(to: CGPoint(x: centerX, y: pad / 2))
            axisPath.addLine(to: CGPoint(x: centerX, y: h - pad / 2))

            context.stroke(
                axisPath,
                with: .color(Color.cyan.opacity(0.45)),
                style: StrokeStyle(lineWidth: 1.2, dash: [4, 3])
            )

            // I-Beam Profile
            var profile = Path()
            profile.move(to: CGPoint(x: leftX, y: topY))
            profile.addLine(to: CGPoint(x: rightX, y: topY))
            profile.addLine(to: CGPoint(x: rightX, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: webRightX, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: webRightX, y: bottomY - drawTf))
            profile.addLine(to: CGPoint(x: rightX, y: bottomY - drawTf))
            profile.addLine(to: CGPoint(x: rightX, y: bottomY))
            profile.addLine(to: CGPoint(x: leftX, y: bottomY))
            profile.addLine(to: CGPoint(x: leftX, y: bottomY - drawTf))
            profile.addLine(to: CGPoint(x: webLeftX, y: bottomY - drawTf))
            profile.addLine(to: CGPoint(x: webLeftX, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: leftX, y: topY + drawTf))
            profile.closeSubpath()

            // 45° Cross Hatching
            drawCrossHatch(context: context, path: profile, bounds: profile.boundingRect)

            // Solid Outline
            context.stroke(profile, with: .color(Color.primary), lineWidth: 2)

            // Dimension callouts
            drawDimension(
                context: context,
                from: CGPoint(x: leftX - 16, y: bottomY),
                to: CGPoint(x: leftX - 16, y: topY),
                text: "h = \(Int(depthH))",
                isVertical: true
            )
            drawDimension(
                context: context,
                from: CGPoint(x: leftX, y: topY - 14),
                to: CGPoint(x: rightX, y: topY - 14),
                text: "bf = \(Int(widthB))",
                isVertical: false
            )
            drawDimension(
                context: context,
                from: CGPoint(x: webRightX + 14, y: centerY - 15),
                to: CGPoint(x: webRightX + 14, y: centerY + 15),
                text: "tw = \(String(format: "%.1f", tw))",
                isVertical: true
            )

            // Flange Slope
            let slope = section.dimensions.flangeSlope_deg ?? 98.0
            drawText(context: context, text: "Ø = \(Int(slope))°", at: CGPoint(x: webRightX + 28, y: topY + drawTf + 14), color: .orange, size: 9)

            // Axis labels
            drawText(context: context, text: "Z", at: CGPoint(x: w - pad + 8, y: centerY), color: .cyan, size: 11)
            drawText(context: context, text: "Z", at: CGPoint(x: pad - 12, y: centerY), color: .cyan, size: 11)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: pad - 12), color: .cyan, size: 11)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: h - pad + 12), color: .cyan, size: 11)
        }
    }

    private func drawCrossHatch(context: GraphicsContext, path: Path, bounds: CGRect) {
        var hatchContext = context
        hatchContext.clip(to: path)

        var hatch = Path()
        let step: CGFloat = 6.0
        var x: CGFloat = bounds.minX - bounds.height
        while x <= bounds.maxX + bounds.height {
            hatch.move(to: CGPoint(x: x, y: bounds.maxY))
            hatch.addLine(to: CGPoint(x: x + bounds.height, y: bounds.minY))
            x += step
        }
        hatchContext.stroke(hatch, with: .color(Color.accentColor.opacity(0.35)), lineWidth: 0.8)
    }

    private func drawDimension(context: GraphicsContext, from: CGPoint, to: CGPoint, text: String, isVertical: Bool) {
        var line = Path()
        line.move(to: from)
        line.addLine(to: to)
        if isVertical {
            line.move(to: CGPoint(x: from.x - 4, y: from.y))
            line.addLine(to: CGPoint(x: from.x + 4, y: from.y))
            line.move(to: CGPoint(x: to.x - 4, y: to.y))
            line.addLine(to: CGPoint(x: to.x + 4, y: to.y))
        } else {
            line.move(to: CGPoint(x: from.x, y: from.y - 4))
            line.addLine(to: CGPoint(x: from.x, y: from.y + 4))
            line.move(to: CGPoint(x: to.x, y: to.y - 4))
            line.addLine(to: CGPoint(x: to.x, y: to.y + 4))
        }
        context.stroke(line, with: .color(Color.secondary), lineWidth: 1)

        let midX = (from.x + to.x) / 2.0
        let midY = (from.y + to.y) / 2.0
        let offsetPt = isVertical ? CGPoint(x: midX - 10, y: midY) : CGPoint(x: midX, y: midY - 8)
        drawText(context: context, text: text, at: offsetPt, color: .secondary, size: 10)
    }

    private func drawText(context: GraphicsContext, text: String, at pt: CGPoint, color: Color, size: CGFloat = 11) {
        let textResolved = Text(text).font(.system(size: size, weight: .semibold, design: .monospaced)).foregroundColor(color)
        context.draw(textResolved, at: pt, anchor: .center)
    }
}
