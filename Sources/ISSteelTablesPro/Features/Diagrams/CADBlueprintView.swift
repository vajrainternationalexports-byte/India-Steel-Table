import SwiftUI

/// Unified 2D CAD Vector Blueprint View for SwiftUI.
public struct CADBlueprintView: View {
    public let section: SteelSection

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height

            if section.family.rawValue.contains("Angles") {
                drawDualAngleBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .flats {
                drawFlatBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .hrPlates {
                drawPlateBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family.rawValue.contains("Beams") {
                drawBeamBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family.rawValue.contains("Channels") {
                drawChannelBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .pipes {
                drawPipeBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .rectangularTubes {
                drawRectTubeBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .squareTubes {
                drawSquareTubeBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .squareBars {
                drawSquareBarBlueprint(ctx: ctx, section: section, w: w, h: h)
            } else if section.family == .roundBars {
                drawRoundBarBlueprint(ctx: ctx, section: section, w: w, h: h)
            }
        }
        .background(Color(red: 0.11, green: 0.12, blue: 0.14))
    }

    // MARK: - Dual Angle Schematic
    private func drawDualAngleBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let legA = section.dimensions.legA_mm ?? 30
        let legB = section.dimensions.legB_mm ?? 20
        let isUnequal = legA != legB

        let ox1: CGFloat = 26
        let oy1: CGFloat = 150
        let da: CGFloat = min(max(CGFloat(legA) * 2.5, 80), 120)
        let db: CGFloat = min(max(CGFloat(legB) * 2.5, 60), 100)
        let dt: CGFloat = 12

        // Top Angle Profile
        var p = Path()
        p.move(to: CGPoint(x: ox1, y: oy1))
        p.addLine(to: CGPoint(x: ox1 + db, y: oy1))
        p.addLine(to: CGPoint(x: ox1 + db, y: oy1 - dt))
        p.addLine(to: CGPoint(x: ox1 + dt + 6, y: oy1 - dt))
        p.addQuadCurve(to: CGPoint(x: ox1 + dt, y: oy1 - dt - 6), control: CGPoint(x: ox1 + dt, y: oy1 - dt))
        p.addLine(to: CGPoint(x: ox1 + dt, y: oy1 - da))
        p.addLine(to: CGPoint(x: ox1, y: oy1 - da))
        p.closeSubpath()

        ctx.stroke(p, with: .color(.white), lineWidth: 1.8)

        // Text Dimensions
        ctx.draw(Text("A").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox1 - 16, y: oy1 - da/2))
        ctx.draw(Text("B").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox1 + db/2, y: oy1 + 14))
        ctx.draw(Text("t").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox1 + dt + 14, y: oy1 - da + 20))

        // Lower Angle Schematic with Axes
        let ox2: CGFloat = 26
        let oy2: CGFloat = 360
        var p2 = Path()
        p2.move(to: CGPoint(x: ox2, y: oy2))
        p2.addLine(to: CGPoint(x: ox2 + db, y: oy2))
        p2.addLine(to: CGPoint(x: ox2 + db, y: oy2 - dt))
        p2.addLine(to: CGPoint(x: ox2 + dt, y: oy2 - dt))
        p2.addLine(to: CGPoint(x: ox2 + dt, y: oy2 - da))
        p2.addLine(to: CGPoint(x: ox2, y: oy2 - da))
        p2.closeSubpath()
        ctx.stroke(p2, with: .color(.white), lineWidth: 1.8)

        let cx = ox2 + (isUnequal ? 20 : 26)
        let cy = oy2 - (isUnequal ? 40 : 26)

        // X-X Dashed
        var xx = Path()
        xx.move(to: CGPoint(x: ox2 - 14, y: cy))
        xx.addLine(to: CGPoint(x: ox2 + db + 16, y: cy))
        ctx.stroke(xx, with: .color(.white), style: StrokeStyle(lineWidth: 1, dash: [6, 3, 2, 3]))

        // Y-Y Dashed
        var yy = Path()
        yy.move(to: CGPoint(x: cx, y: oy2 - da - 12))
        yy.addLine(to: CGPoint(x: cx, y: oy2 + 12))
        ctx.stroke(yy, with: .color(.white), style: StrokeStyle(lineWidth: 1, dash: [6, 3, 2, 3]))

        ctx.draw(Text("X").font(.system(size: 9, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox2 - 20, y: cy))
        ctx.draw(Text("X").font(.system(size: 9, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox2 + db + 22, y: cy))
        ctx.draw(Text("Y").font(.system(size: 9, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: oy2 - da - 18))
        ctx.draw(Text("Y").font(.system(size: 9, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: oy2 + 18))
        ctx.draw(Text("Cx").font(.system(size: 9, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox2 + 6, y: cy + 10))
        ctx.draw(Text("Cy").font(.system(size: 9, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx - 12, y: oy2 + 6))
    }

    // MARK: - Flat Blueprint
    private func drawFlatBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let rect = CGRect(x: 24, y: 130, width: 115, height: 22)
        ctx.stroke(Path(rect), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("w").font(.system(size: 11, weight: .bold)).foregroundColor(.white), at: CGPoint(x: 81, y: 114))
        ctx.draw(Text("t").font(.system(size: 11, weight: .bold)).foregroundColor(.white), at: CGPoint(x: 10, y: 141))
    }

    // MARK: - Plate Blueprint
    private func drawPlateBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let rect = CGRect(x: 65, y: 60, width: 22, height: 250)
        ctx.stroke(Path(rect), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("t").font(.system(size: 11, weight: .bold)).foregroundColor(.white), at: CGPoint(x: 76, y: 44))
    }

    // MARK: - Beam Blueprint
    private func drawBeamBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let cx: CGFloat = 80
        let cy: CGFloat = 190
        let bh: CGFloat = 200
        let bw: CGFloat = 100
        let tw: CGFloat = 12
        let tf: CGFloat = 16

        var p = Path()
        p.move(to: CGPoint(x: cx - bw/2, y: cy - bh/2))
        p.addLine(to: CGPoint(x: cx + bw/2, y: cy - bh/2))
        p.addLine(to: CGPoint(x: cx + bw/2, y: cy - bh/2 + tf))
        p.addLine(to: CGPoint(x: cx + tw/2, y: cy - bh/2 + tf))
        p.addLine(to: CGPoint(x: cx + tw/2, y: cy + bh/2 - tf))
        p.addLine(to: CGPoint(x: cx + bw/2, y: cy + bh/2 - tf))
        p.addLine(to: CGPoint(x: cx + bw/2, y: cy + bh/2))
        p.addLine(to: CGPoint(x: cx - bw/2, y: cy + bh/2))
        p.addLine(to: CGPoint(x: cx - bw/2, y: cy + bh/2 - tf))
        p.addLine(to: CGPoint(x: cx - tw/2, y: cy + bh/2 - tf))
        p.addLine(to: CGPoint(x: cx - tw/2, y: cy - bh/2 + tf))
        p.addLine(to: CGPoint(x: cx - bw/2, y: cy - bh/2 + tf))
        p.closeSubpath()

        ctx.stroke(p, with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("D").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx - bw/2 - 18, y: cy))
        ctx.draw(Text("B").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy - bh/2 - 14))
        ctx.draw(Text("T").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx + bw/2 + 14, y: cy - bh/2 + tf/2))
        ctx.draw(Text("t").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy + 24))
    }

    // MARK: - Channel Blueprint
    private func drawChannelBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let ox: CGFloat = 35
        let cy: CGFloat = 190
        let ch: CGFloat = 200
        let cw: CGFloat = 85
        let tw: CGFloat = 12
        let tf: CGFloat = 16

        var p = Path()
        p.move(to: CGPoint(x: ox + cw, y: cy - ch/2))
        p.addLine(to: CGPoint(x: ox, y: cy - ch/2))
        p.addLine(to: CGPoint(x: ox, y: cy + ch/2))
        p.addLine(to: CGPoint(x: ox + cw, y: cy + ch/2))
        p.addLine(to: CGPoint(x: ox + cw, y: cy + ch/2 - tf))
        p.addLine(to: CGPoint(x: ox + tw, y: cy + ch/2 - tf))
        p.addLine(to: CGPoint(x: ox + tw, y: cy - ch/2 + tf))
        p.addLine(to: CGPoint(x: ox + cw, y: cy - ch/2 + tf))
        p.closeSubpath()

        ctx.stroke(p, with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("D").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox - 16, y: cy))
        ctx.draw(Text("B").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox + cw/2, y: cy - ch/2 - 14))
        ctx.draw(Text("Cy").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: ox + 8, y: cy + ch/2 + 12))
    }

    // MARK: - Pipe Blueprint
    private func drawPipeBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let cx: CGFloat = 80
        let cy: CGFloat = 190
        let rOuter: CGFloat = 60
        let rInner: CGFloat = 44

        ctx.stroke(Path(ellipseIn: CGRect(x: cx - rOuter, y: cy - rOuter, width: rOuter*2, height: rOuter*2)), with: .color(.white), lineWidth: 1.8)
        ctx.stroke(Path(ellipseIn: CGRect(x: cx - rInner, y: cy - rInner, width: rInner*2, height: rInner*2)), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("OD").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy - rOuter - 14))
        ctx.draw(Text("t").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx + rOuter - 8, y: cy - rOuter + 24))
    }

    // MARK: - Rect Tube Blueprint
    private func drawRectTubeBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let cx: CGFloat = 80
        let cy: CGFloat = 190
        let tw: CGFloat = 110
        let th: CGFloat = 65
        let wall: CGFloat = 12

        let r1 = CGRect(x: cx - tw/2, y: cy - th/2, width: tw, height: th)
        let r2 = CGRect(x: cx - tw/2 + wall, y: cy - th/2 + wall, width: tw - wall*2, height: th - wall*2)

        ctx.stroke(Path(roundedRect: r1, cornerRadius: 6), with: .color(.white), lineWidth: 1.8)
        ctx.stroke(Path(roundedRect: r2, cornerRadius: 4), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("B").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy - th/2 - 14))
        ctx.draw(Text("D").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx + tw/2 + 14, y: cy))
    }

    // MARK: - Square Tube Blueprint
    private func drawSquareTubeBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let cx: CGFloat = 80
        let cy: CGFloat = 190
        let s: CGFloat = 85
        let wall: CGFloat = 12

        let r1 = CGRect(x: cx - s/2, y: cy - s/2, width: s, height: s)
        let r2 = CGRect(x: cx - s/2 + wall, y: cy - s/2 + wall, width: s - wall*2, height: s - wall*2)

        ctx.stroke(Path(roundedRect: r1, cornerRadius: 6), with: .color(.white), lineWidth: 1.8)
        ctx.stroke(Path(roundedRect: r2, cornerRadius: 4), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("D").font(.system(size: 10, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy - s/2 - 14))
    }

    // MARK: - Square Bar Blueprint
    private func drawSquareBarBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let cx: CGFloat = 80
        let cy: CGFloat = 190
        let s: CGFloat = 85

        ctx.stroke(Path(CGRect(x: cx - s/2, y: cy - s/2, width: s, height: s)), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("t").font(.system(size: 11, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy - s/2 - 14))
    }

    // MARK: - Round Bar Blueprint
    private func drawRoundBarBlueprint(ctx: GraphicsContext, section: SteelSection, w: CGFloat, h: CGFloat) {
        let cx: CGFloat = 80
        let cy: CGFloat = 190
        let r: CGFloat = 45

        ctx.stroke(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r*2, height: r*2)), with: .color(.white), lineWidth: 1.8)

        ctx.draw(Text("t").font(.system(size: 11, weight: .bold)).foregroundColor(.white), at: CGPoint(x: cx, y: cy - r - 14))
    }
}
