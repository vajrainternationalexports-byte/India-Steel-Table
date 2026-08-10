import SwiftUI

/// Parametric technical vector diagram for Square & Rectangular Hollow Sections (SHS & RHS - IS 4923).
public struct HollowSectionDiagramView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let pad: CGFloat = 36

            let depthH = CGFloat(section.dimensions.depth_h_mm ?? 60)
            let widthB = CGFloat(section.dimensions.width_b_mm ?? 40)
            let t = CGFloat(section.dimensions.wallThickness_t_mm ?? 3.2)

            let availW = w - 2 * pad
            let availH = h - 2 * pad
            let scale = min(availW / max(widthB, 60), availH / max(depthH, 60)) * 0.8

            let drawH = depthH * scale
            let drawB = widthB * scale
            let drawT = max(t * scale, 5.0)

            let centerX = w / 2.0
            let centerY = h / 2.0

            let outerRect = CGRect(
                x: centerX - drawB / 2.0,
                y: centerY - drawH / 2.0,
                width: drawB,
                height: drawH
            )
            let innerRect = CGRect(
                x: outerRect.minX + drawT,
                y: outerRect.minY + drawT,
                width: drawB - 2 * drawT,
                height: drawH - 2 * drawT
            )

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

            // Outer & Inner Rounded Rectangles
            let outerCorner = CGFloat(drawT * 1.5)
            let innerCorner = CGFloat(drawT * 0.5)

            var hollowPath = Path()
            hollowPath.addRoundedRect(in: outerRect, cornerSize: CGSize(width: outerCorner, height: outerCorner))
            hollowPath.addRoundedRect(in: innerRect, cornerSize: CGSize(width: innerCorner, height: innerCorner))

            context.fill(hollowPath, with: .color(Color.accentColor.opacity(0.18)), style: FillStyle(eoFill: true))
            context.stroke(
                Path(roundedRect: outerRect, cornerSize: CGSize(width: outerCorner, height: outerCorner)),
                with: .color(Color.primary),
                lineWidth: 2
            )
            context.stroke(
                Path(roundedRect: innerRect, cornerSize: CGSize(width: innerCorner, height: innerCorner)),
                with: .color(Color.primary),
                lineWidth: 1.5
            )

            // Dimensions
            drawDimension(
                context: context,
                from: CGPoint(x: outerRect.minX - 16, y: outerRect.maxY),
                to: CGPoint(x: outerRect.minX - 16, y: outerRect.minY),
                text: "h = \(Int(depthH)) mm",
                isVertical: true
            )
            drawDimension(
                context: context,
                from: CGPoint(x: outerRect.minX, y: outerRect.minY - 14),
                to: CGPoint(x: outerRect.maxX, y: outerRect.minY - 14),
                text: "b = \(Int(widthB)) mm",
                isVertical: false
            )
            drawText(
                context: context,
                text: "t = \(String(format: "%.1f", t)) mm",
                at: CGPoint(x: outerRect.maxX + 24, y: centerY),
                color: .orange,
                size: 10
            )

            // Axis labels
            drawText(context: context, text: "X", at: CGPoint(x: w - pad + 8, y: centerY), color: .cyan)
            drawText(context: context, text: "X", at: CGPoint(x: pad - 12, y: centerY), color: .cyan)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: pad - 12), color: .cyan)
            drawText(context: context, text: "Y", at: CGPoint(x: centerX, y: h - pad + 12), color: .cyan)
        }
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
