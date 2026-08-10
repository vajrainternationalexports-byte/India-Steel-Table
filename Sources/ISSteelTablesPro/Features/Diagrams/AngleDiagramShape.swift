import SwiftUI

/// Parametric CAD Vector Blueprint Technical Diagram for Equal and Unequal Angles (ISA).
/// Implements dual schematic mode:
/// 1. Top Schematic: Geometric profile with dimensional callouts (A, B, t, R1 root radius, R2 toe radius).
/// 2. Bottom Schematic: Centroidal & Principal coordinate systems (X-X, Y-Y, U-U, V-V, Cx, Cy, ex, ey, alpha).
public struct AngleDiagramView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height

            let legA = CGFloat(section.dimensions.legA_mm ?? 50)
            let legB = CGFloat(section.dimensions.legB_mm ?? section.dimensions.legA_mm ?? 50)
            let t = CGFloat(section.dimensions.thickness_t_mm ?? 5)
            let cx = CGFloat(section.structural.cx_cm ?? (Double(legB) / 30.0)) * 10.0 // mm
            let cy = CGFloat(section.structural.cy_cm ?? (Double(legA) / 30.0)) * 10.0 // mm
            let r1 = CGFloat(section.dimensions.rootRadius_r1_mm ?? 5.0)

            let isUnequal = legA != legB

            // We divide canvas into two schematic zones if height allows, or unified schematic
            let pad: CGFloat = 28
            let maxDim = max(legA, legB)
            let availW = (w / 2.0) - pad * 1.5
            let availH = h - 2 * pad
            let scale = min(availW / maxDim, availH / maxDim) * 0.85

            let drawA = legA * scale
            let drawB = legB * scale
            let drawT = max(t * scale, 7.0)
            let drawR1 = max(r1 * scale, 3.0)

            // -------------------------------------------------------------
            // SCHEMATIC 1 (LEFT): Dimensional Cross-Section Profile
            // -------------------------------------------------------------
            let originX1 = pad + 10
            let originY1 = h - pad - 10

            var profilePath1 = Path()
            profilePath1.move(to: CGPoint(x: originX1, y: originY1))
            profilePath1.addLine(to: CGPoint(x: originX1 + drawB, y: originY1))
            profilePath1.addLine(to: CGPoint(x: originX1 + drawB, y: originY1 - drawT))
            profilePath1.addLine(to: CGPoint(x: originX1 + drawT + drawR1, y: originY1 - drawT))
            // Root radius arc
            profilePath1.addQuadCurve(
                to: CGPoint(x: originX1 + drawT, y: originY1 - drawT - drawR1),
                control: CGPoint(x: originX1 + drawT, y: originY1 - drawT)
            )
            profilePath1.addLine(to: CGPoint(x: originX1 + drawT, y: originY1 - drawA))
            profilePath1.addLine(to: CGPoint(x: originX1, y: originY1 - drawA))
            profilePath1.closeSubpath()

            // Draw 45° CAD Cross-Hatch Pattern
            drawCrossHatch(context: context, path: profilePath1, bounds: profilePath1.boundingRect)

            // Outline
            context.stroke(profilePath1, with: .color(Color.primary), lineWidth: 2)

            // Dimension callouts (Schematic 1)
            drawDimension(
                context: context,
                from: CGPoint(x: originX1 - 14, y: originY1),
                to: CGPoint(x: originX1 - 14, y: originY1 - drawA),
                text: "A = \(Int(legA))",
                isVertical: true
            )
            drawDimension(
                context: context,
                from: CGPoint(x: originX1, y: originY1 + 14),
                to: CGPoint(x: originX1 + drawB, y: originY1 + 14),
                text: isUnequal ? "B = \(Int(legB))" : "B = \(Int(legB))",
                isVertical: false
            )
            drawDimension(
                context: context,
                from: CGPoint(x: originX1 + drawT + 12, y: originY1 - drawT),
                to: CGPoint(x: originX1 + drawT + 12, y: originY1),
                text: "t = \(section.dimensions.thickness_t_mm ?? 0)",
                isVertical: true
            )

            // Root & Toe Radius Callouts
            drawText(context: context, text: "R₁ ROOT", at: CGPoint(x: originX1 + drawT + drawR1 + 22, y: originY1 - drawT - drawR1 - 4), color: .orange, size: 8)
            let r2Label = section.dimensions.toeRadius_r2_description ?? "R₂"
            drawText(context: context, text: "R₂ \(r2Label.uppercased())", at: CGPoint(x: originX1 + drawT + 16, y: originY1 - drawA - 6), color: .orange, size: 8)

            // -------------------------------------------------------------
            // SCHEMATIC 2 (RIGHT): Principal Axes & Centroid Coordinate System
            // -------------------------------------------------------------
            let originX2 = w / 2.0 + pad
            let originY2 = originY1

            var profilePath2 = Path()
            profilePath2.move(to: CGPoint(x: originX2, y: originY2))
            profilePath2.addLine(to: CGPoint(x: originX2 + drawB, y: originY2))
            profilePath2.addLine(to: CGPoint(x: originX2 + drawB, y: originY2 - drawT))
            profilePath2.addLine(to: CGPoint(x: originX2 + drawT, y: originY2 - drawT))
            profilePath2.addLine(to: CGPoint(x: originX2 + drawT, y: originY2 - drawA))
            profilePath2.addLine(to: CGPoint(x: originX2, y: originY2 - drawA))
            profilePath2.closeSubpath()

            drawCrossHatch(context: context, path: profilePath2, bounds: profilePath2.boundingRect, opacity: 0.25)
            context.stroke(profilePath2, with: .color(Color.primary.opacity(0.8)), lineWidth: 1.5)

            // Centroid Center Point (C)
            let drawCx = cx * scale
            let drawCy = cy * scale
            let cPoint = CGPoint(x: originX2 + drawCx, y: originY2 - drawCy)

            // X-X Axis (Neutral bending)
            var axisX = Path()
            axisX.move(to: CGPoint(x: originX2 - 20, y: cPoint.y))
            axisX.addLine(to: CGPoint(x: originX2 + drawB + 20, y: cPoint.y))
            context.stroke(axisX, with: .color(Color.cyan), style: StrokeStyle(lineWidth: 1.2, dash: [4, 3]))

            // Y-Y Axis
            var axisY = Path()
            axisY.move(to: CGPoint(x: cPoint.x, y: originY2 - drawA - 16))
            axisY.addLine(to: CGPoint(x: cPoint.x, y: originY2 + 16))
            context.stroke(axisY, with: .color(Color.cyan), style: StrokeStyle(lineWidth: 1.2, dash: [4, 3]))

            // U-U Axis (Principal major axis)
            let tanAlpha = CGFloat(section.structural.tanAlpha ?? (isUnequal ? 0.43 : 1.0))
            let alphaAngle = atan(tanAlpha)
            let axisLen: CGFloat = 55

            var axisU = Path()
            axisU.move(to: CGPoint(x: cPoint.x - axisLen * cos(alphaAngle), y: cPoint.y + axisLen * sin(alphaAngle)))
            axisU.addLine(to: CGPoint(x: cPoint.x + axisLen * cos(alphaAngle), y: cPoint.y - axisLen * sin(alphaAngle)))
            context.stroke(axisU, with: .color(Color.orange), style: StrokeStyle(lineWidth: 1.2, dash: [4, 2]))

            // V-V Axis (Principal minor axis perpendicular to U-U)
            var axisV = Path()
            axisV.move(to: CGPoint(x: cPoint.x - axisLen * sin(alphaAngle), y: cPoint.y - axisLen * cos(alphaAngle)))
            axisV.addLine(to: CGPoint(x: cPoint.x + axisLen * sin(alphaAngle), y: cPoint.y + axisLen * cos(alphaAngle)))
            context.stroke(axisV, with: .color(Color.orange), style: StrokeStyle(lineWidth: 1.2, dash: [4, 2]))

            // Centroid marker dot
            context.fill(Path(ellipseIn: CGRect(x: cPoint.x - 2.5, y: cPoint.y - 2.5, width: 5, height: 5)), with: .color(Color.red))

            // Centroid offset dimensions
            drawText(context: context, text: "Cx=\(String(format: "%.2f", cx/10))", at: CGPoint(x: originX2 + drawCx / 2.0, y: originY2 + 8), color: .secondary, size: 8)
            drawText(context: context, text: "Cy=\(String(format: "%.2f", cy/10))", at: CGPoint(x: originX2 - 8, y: originY2 - drawCy / 2.0), color: .secondary, size: 8)

            // Axis labels
            drawText(context: context, text: "X", at: CGPoint(x: originX2 + drawB + 24, y: cPoint.y), color: .cyan, size: 10)
            drawText(context: context, text: "Y", at: CGPoint(x: cPoint.x, y: originY2 - drawA - 20), color: .cyan, size: 10)
            drawText(context: context, text: "U", at: CGPoint(x: cPoint.x + axisLen * cos(alphaAngle) + 8, y: cPoint.y - axisLen * sin(alphaAngle) - 4), color: .orange, size: 10)
            drawText(context: context, text: "V", at: CGPoint(x: cPoint.x - axisLen * sin(alphaAngle) - 8, y: cPoint.y - axisLen * cos(alphaAngle) - 4), color: .orange, size: 10)

            if isUnequal {
                drawText(context: context, text: "α", at: CGPoint(x: cPoint.x + 16, y: cPoint.y - 6), color: .orange, size: 9)
            }
        }
    }

    private func drawCrossHatch(context: GraphicsContext, path: Path, bounds: CGRect, opacity: Double = 0.35) {
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
        hatchContext.stroke(hatch, with: .color(Color.accentColor.opacity(opacity)), lineWidth: 0.8)
    }

    private func drawDimension(context: GraphicsContext, from: CGPoint, to: CGPoint, text: String, isVertical: Bool) {
        var line = Path()
        line.move(to: from)
        line.addLine(to: to)
        if isVertical {
            line.move(to: CGPoint(x: from.x - 3, y: from.y))
            line.addLine(to: CGPoint(x: from.x + 3, y: from.y))
            line.move(to: CGPoint(x: to.x - 3, y: to.y))
            line.addLine(to: CGPoint(x: to.x + 3, y: to.y))
        } else {
            line.move(to: CGPoint(x: from.x, y: from.y - 3))
            line.addLine(to: CGPoint(x: from.x, y: from.y + 3))
            line.move(to: CGPoint(x: to.x, y: to.y - 3))
            line.addLine(to: CGPoint(x: to.x, y: to.y + 3))
        }
        context.stroke(line, with: .color(Color.secondary), lineWidth: 1)

        let midX = (from.x + to.x) / 2.0
        let midY = (from.y + to.y) / 2.0
        let offsetPt = isVertical ? CGPoint(x: midX - 8, y: midY) : CGPoint(x: midX, y: midY + 8)
        drawText(context: context, text: text, at: offsetPt, color: .secondary, size: 9)
    }

    private func drawText(context: GraphicsContext, text: String, at pt: CGPoint, color: Color, size: CGFloat = 10) {
        let textResolved = Text(text).font(.system(size: size, weight: .semibold, design: .monospaced)).foregroundColor(color)
        context.draw(textResolved, at: pt, anchor: .center)
    }
}
