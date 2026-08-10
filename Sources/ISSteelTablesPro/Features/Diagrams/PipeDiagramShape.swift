import SwiftUI

/// Parametric technical vector diagram for Circular Steel Pipes and Tubes (IS 1161 / IS 1239).
public struct PipeDiagramView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let pad: CGFloat = 36

            let od = CGFloat(section.dimensions.outerDiameter_od_mm ?? 60.3)
            let t = CGFloat(section.dimensions.wallThickness_t_mm ?? 3.6)
            let id = od - (2.0 * t)

            let centerX = w / 2.0
            let centerY = h / 2.0

            let maxRadius = (min(w, h) - 2 * pad) / 2.0 * 0.8
            let outerRadius = maxRadius
            let innerRadius = maxRadius * (id / od)

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

            // Outer Circle
            let outerRect = CGRect(
                x: centerX - outerRadius,
                y: centerY - outerRadius,
                width: outerRadius * 2,
                height: outerRadius * 2
            )
            let innerRect = CGRect(
                x: centerX - innerRadius,
                y: centerY - innerRadius,
                width: innerRadius * 2,
                height: innerRadius * 2
            )

            var tubePath = Path()
            tubePath.addEllipse(in: outerRect)
            tubePath.addEllipse(in: innerRect)

            context.fill(tubePath, with: .color(Color.accentColor.opacity(0.18)), style: FillStyle(eoFill: true))
            context.stroke(Path(ellipseIn: outerRect), with: .color(Color.primary), lineWidth: 2)
            context.stroke(Path(ellipseIn: innerRect), with: .color(Color.primary), lineWidth: 1.5)

            // Dimension callout for OD
            drawDimension(
                context: context,
                from: CGPoint(x: centerX - outerRadius, y: centerY - outerRadius - 16),
                to: CGPoint(x: centerX + outerRadius, y: centerY - outerRadius - 16),
                text: "OD = \(String(format: "%.1f", od)) mm",
                isVertical: false
            )

            // Wall thickness callout
            drawText(
                context: context,
                text: "t = \(String(format: "%.1f", t)) mm",
                at: CGPoint(x: centerX + (outerRadius + innerRadius) / 2.0, y: centerY + 18),
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
        line.move(to: CGPoint(x: from.x, y: from.y - 4))
        line.addLine(to: CGPoint(x: from.x, y: from.y + 4))
        line.move(to: CGPoint(x: to.x, y: to.y - 4))
        line.addLine(to: CGPoint(x: to.x, y: to.y + 4))
        context.stroke(line, with: .color(Color.secondary), lineWidth: 1)

        let midX = (from.x + to.x) / 2.0
        let midY = (from.y + to.y) / 2.0
        drawText(context: context, text: text, at: CGPoint(x: midX, y: midY - 8), color: .secondary, size: 10)
    }

    private func drawText(context: GraphicsContext, text: String, at pt: CGPoint, color: Color, size: CGFloat = 11) {
        let textResolved = Text(text).font(.system(size: size, weight: .semibold, design: .monospaced)).foregroundColor(color)
        context.draw(textResolved, at: pt, anchor: .center)
    }
}
