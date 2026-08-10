import SwiftUI

/// Parametric CAD Vector Blueprint Technical Diagram for C-Channels (ISMC, ISJC, ISLC, ISPC, NPFC).
public struct ChannelDiagramView: View {
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
            let cy = CGFloat(section.structural.cy_cm ?? 2.0) * 10.0 // mm
            let r1 = CGFloat(section.dimensions.rootRadius_R_mm ?? 8.5)

            let availW = w - 2 * pad
            let availH = h - 2 * pad
            let scale = min(availW / max(widthB * 1.5, 100), availH / max(depthH, 100)) * 0.85

            let drawH = depthH * scale
            let drawB = widthB * scale
            let drawTw = max(tw * scale, 5.0)
            let drawTf = max(tf * scale, 7.0)
            let drawCy = cy * scale
            let drawR1 = max(r1 * scale, 4.0)

            let centerY = h / 2.0
            let originX = pad + 30
            let topY = centerY - drawH / 2.0
            let bottomY = centerY + drawH / 2.0

            let cx = originX + drawCy

            // Neutral Axes (Z-Z horizontal, Y-Y vertical through centroid)
            var axisPath = Path()
            axisPath.move(to: CGPoint(x: pad / 2, y: centerY))
            axisPath.addLine(to: CGPoint(x: w - pad / 2, y: centerY))
            axisPath.move(to: CGPoint(x: cx, y: pad / 2))
            axisPath.addLine(to: CGPoint(x: cx, y: h - pad / 2))

            context.stroke(
                axisPath,
                with: .color(Color.cyan.opacity(0.45)),
                style: StrokeStyle(lineWidth: 1.2, dash: [4, 3])
            )

            // C-Channel Profile with Root Radius
            var profile = Path()
            profile.move(to: CGPoint(x: originX, y: topY))
            profile.addLine(to: CGPoint(x: originX + drawB, y: topY))
            profile.addLine(to: CGPoint(x: originX + drawB, y: topY + drawTf))
            profile.addLine(to: CGPoint(x: originX + drawTw + drawR1, y: topY + drawTf))
            profile.addQuadCurve(
                to: CGPoint(x: originX + drawTw, y: topY + drawTf + drawR1),
                control: CGPoint(x: originX + drawTw, y: topY + drawTf)
            )
            profile.addLine(to: CGPoint(x: originX + drawTw, y: bottomY - drawTf - drawR1))
            profile.addQuadCurve(
                to: CGPoint(x: originX + drawTw + drawR1, y: bottomY - drawTf),
                control: CGPoint(x: originX + drawTw, y: bottomY - drawTf)
            )
            profile.addLine(to: CGPoint(x: originX + drawB, y: bottomY - drawTf))
            profile.addLine(to: CGPoint(x: originX + drawB, y: bottomY))
            profile.addLine(to: CGPoint(x: originX, y: bottomY))
            profile.closeSubpath()

            // 45° Cross Hatching
            drawCrossHatch(context: context, path: profile, bounds: profile.boundingRect)

            // Outline
            context.stroke(profile, with: .color(Color.primary), lineWidth: 2)

            // Centroid marker dot
            context.fill(Path(ellipseIn: CGRect(x: cx - 2.5, y: centerY - 2.5, width: 5, height: 5)), with: .color(Color.red))

            // Dimension callouts
            drawDimension(
                context: context,
                from: CGPoint(x: originX - 16, y: bottomY),
                to: CGPoint(x: originX - 16, y: topY),
                text: "h = \(Int(depthH))",
                isVertical: true
            )
            drawDimension(
                context: context,
                from: CGPoint(x: originX, y: topY - 14),
                to: CGPoint(x: originX + drawB, y: topY - 14),
                text: "bf = \(Int(widthB))",
                isVertical: false
            )
            drawDimension(
                context: context,
                from: CGPoint(x: originX, y: bottomY + 16),
                to: CGPoint(x: cx, y: bottomY + 16),
                text: "Cy = \(String(format: "%.2f", cy / 10.0)) cm",
                isVertical: false
            )

            // Axis labels
            drawText(context: context, text: "Z", at: CGPoint(x: w - pad + 8, y: centerY), color: .cyan, size: 11)
            drawText(context: context, text: "Z", at: CGPoint(x: pad - 12, y: centerY), color: .cyan, size: 11)
            drawText(context: context, text: "Y", at: CGPoint(x: cx, y: pad - 12), color: .cyan, size: 11)
            drawText(context: context, text: "Y", at: CGPoint(x: cx, y: h - pad + 12), color: .cyan, size: 11)
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
        let offsetPt = isVertical ? CGPoint(x: midX - 10, y: midY) : CGPoint(x: midX, y: midY + 10)
        drawText(context: context, text: text, at: offsetPt, color: .secondary, size: 10)
    }

    private func drawText(context: GraphicsContext, text: String, at pt: CGPoint, color: Color, size: CGFloat = 11) {
        let textResolved = Text(text).font(.system(size: size, weight: .semibold, design: .monospaced)).foregroundColor(color)
        context.draw(textResolved, at: pt, anchor: .center)
    }
}
