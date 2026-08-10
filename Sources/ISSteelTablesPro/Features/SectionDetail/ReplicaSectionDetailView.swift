import SwiftUI

/// Screen 2: Exact Detail View matching Android IS Steel Table v1.4.3 Screenshots 2, 5, 9345-9360.
public struct ReplicaSectionDetailView: View {
    public let section: SteelSection
    public let onOpenSizePicker: () -> Void
    public let onOpenCalculator: () -> Void

    @State private var isBookmarked: Bool = false

    public init(
        section: SteelSection,
        onOpenSizePicker: @escaping () -> Void,
        onOpenCalculator: @escaping () -> Void
    ) {
        self.section = section
        self.onOpenSizePicker = onOpenSizePicker
        self.onOpenCalculator = onOpenCalculator
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Sub-Header Bar: Upward Triangle ▲ + Designation
            Button {
                onOpenSizePicker()
            } label: {
                HStack {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                    Spacer()
                    Text(cleanDesignation(section))
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
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 6)

            // Split View Body
            HStack(alignment: .top, spacing: 10) {
                // Left CAD Schematic Diagram Pane (48% width)
                CADBlueprintView(section: section)
                    .frame(width: 170, height: 410)

                // Right Properties Pane (52% width)
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(generatePropertyLines(section), id: \.self) { line in
                            Text(line)
                                .font(.system(size: 13, weight: .regular, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 4)

            Spacer()

            // Bottom Legend & BIS Code Box
            VStack(spacing: 3) {
                if section.family == .pipes {
                    Text("Ar=Area of cross-section  V=Internal volume\nSi=Internal Surface area  Se=External Surface area\nIxx=MI about X-X axis  Rx=Radius of Gyration")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 0.80, green: 0.82, blue: 0.85))
                        .multilineTextAlignment(.center)
                    Text("IS:1161(1998)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.36, green: 0.82, blue: 0.90))
                } else if section.family == .rectangularTubes || section.family == .squareTubes {
                    Text("Moment of Inertia = I  Radius of Gyration = R\nElastic Modulus = Z  Plastic Modulus = S")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 0.80, green: 0.82, blue: 0.85))
                        .multilineTextAlignment(.center)
                    Text("IS:4923")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.36, green: 0.82, blue: 0.90))
                } else if section.family.rawValue.contains("Beams") || section.family.rawValue.contains("Channels") || section.family.rawValue.contains("Angles") {
                    Text(section.standard)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.36, green: 0.82, blue: 0.90))
                } else {
                    Text(section.standard)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.36, green: 0.82, blue: 0.90))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.11, green: 0.12, blue: 0.14))
        }
        .background(Color(red: 0.13, green: 0.14, blue: 0.16))
        .navigationTitle(section.family.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        // Share
                        let text = "\(section.designation) - Mass: \(section.massPerMetre) kg/m"
                        #if canImport(UIKit)
                        UIPasteboard.general.string = text
                        #endif
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                    }

                    Button {
                        isBookmarked.toggle()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.white)
                    }

                    Button {
                        onOpenCalculator()
                    } label: {
                        Image(systemName: "plus.slash.minus")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private func cleanDesignation(_ s: SteelSection) -> String {
        var d = s.designation
        d = d.replacingOccurrences(of: "^ISA\\s+", with: "", options: .regularExpression)
        d = d.replacingOccurrences(of: "^FLAT\\s+", with: "", options: .regularExpression)
        d = d.replacingOccurrences(of: "^PLATE\\s+", with: "", options: .regularExpression)
        return d
    }

    private func generatePropertyLines(_ s: SteelSection) -> [String] {
        var lines: [String] = []
        let d = s.dimensions
        let st = s.structural

        if s.family.rawValue.contains("Angles") {
            lines.append("M = \(s.massPerMetre) Kg/m")
            lines.append("Ar = \(s.area) cm²")
            if let a = d.legA_mm {
                let b = d.legB_mm ?? a
                lines.append("A,B = \(formatVal(a)) \(formatVal(b)) mm")
            }
            if let t = d.thickness_t_mm { lines.append("t = \(formatVal(t)) mm") }
            if let r1 = d.rootRadius_r1_mm { lines.append("R₁ = \(formatVal(r1)) mm") }
            if let r2 = d.toeRadius_r2_description { lines.append("R₂ = \(r2)") }
            if let cx = st.cx_cm { lines.append("C_x = \(cx) cm") }
            if let cy = st.cy_cm { lines.append("C_y = \(cy) cm") }
            if let tan = st.tanAlpha { lines.append("Tan α = \(tan)") }
            if let ix = st.ixx_cm4 { lines.append("I_x = \(ix) cm⁴") }
            if let iy = st.iyy_cm4 { lines.append("I_y = \(iy) cm⁴") }
            if let iu = st.iuMax_cm4 { lines.append("I_u max = \(iu) cm⁴") }
            if let iv = st.ivMin_cm4 { lines.append("I_v min = \(iv) cm⁴") }
            if let rx = st.rxx_cm { lines.append("r_x = \(rx) cm") }
            if let ry = st.ryy_cm { lines.append("r_y = \(ry) cm") }
            if let ru = st.ruMax_cm { lines.append("r_u max = \(ru) cm") }
            if let rv = st.rvMin_cm { lines.append("r_v min = \(rv) cm") }
            if let zx = st.zxx_cm3 { lines.append("Z_x = \(zx) cm³") }
            if let zy = st.zyy_cm3 { lines.append("Z_y = \(zy) cm³") }
        } else if s.family == .pipes {
            if let od = d.outerDiameter_od_mm { lines.append("OD = \(formatVal(od)) mm") }
            if let t = d.wallThickness_t_mm { lines.append("t = \(formatVal(t)) mm") }
            lines.append("Wt = \(s.massPerMetre) Kg/m")
            lines.append("Ar = \(s.area) cm²")
            if let v = s.surface?.internalVolume_cm3PerM { lines.append("V = \(v) cm³/m") }
            if let se = s.surface?.externalSurface_cm2PerM { lines.append("Se = \(se) cm²/m") }
            if let si = s.surface?.internalSurface_cm2PerM { lines.append("Si = \(si) cm²/m") }
            if let ix = st.ixx_cm4 { lines.append("Ixx = \(ix) cm⁴") }
            if let zx = st.zxx_cm3 { lines.append("Z = \(zx) cm³") }
            if let rx = st.rxx_cm { lines.append("Rx = \(rx) cm") }
        } else if s.family == .rectangularTubes || s.family == .squareTubes {
            if s.family == .squareTubes {
                if let side = d.side_s_mm ?? d.depth_h_mm { lines.append("D = \(formatVal(side)) mm") }
            }
            if let t = d.wallThickness_t_mm ?? d.thickness_t_mm { lines.append("t = \(formatVal(t)) mm") }
            lines.append("Wt = \(s.massPerMetre) Kg/m")
            lines.append("Ar = \(s.area) cm²")
            if let ix = st.ixx_cm4, s.family == .rectangularTubes { lines.append("Ixx = \(ix) cm⁴") }
            if let iy = st.iyy_cm4 { lines.append("\(s.family == .squareTubes ? "Iy" : "Iyy") = \(iy) cm⁴") }
            if let rx = st.rxx_cm { lines.append("Rx = \(rx) cm") }
            if let ry = st.ryy_cm, s.family == .rectangularTubes { lines.append("Ry = \(ry) cm") }
            if let zx = st.zxx_cm3 { lines.append("Zx = \(zx) cm³") }
            if let zy = st.zyy_cm3, s.family == .rectangularTubes { lines.append("Zy = \(zy) cm³") }
            if let sx = st.zp_x_cm3 { lines.append("Sx = \(sx) cm³") }
            if let sy = st.zp_y_cm3, s.family == .rectangularTubes { lines.append("Sy = \(sy) cm³") }
        } else if s.family.rawValue.contains("Beams") {
            lines.append("M = \(s.massPerMetre) Kg/m")
            lines.append("Ar = \(s.area) cm²")
            if let h = d.depth_h_mm { lines.append("D = \(formatVal(h)) mm") }
            if let b = d.width_b_mm { lines.append("B = \(formatVal(b)) mm") }
            if let tw = d.webThickness_tw_mm { lines.append("t = \(formatVal(tw)) mm") }
            if let tf = d.flangeThickness_tf_mm { lines.append("T = \(formatVal(tf)) mm") }
            lines.append("Slope α = \(formatVal(d.flangeSlope_deg ?? 98)) deg")
            if let r1 = d.rootRadius_r1_mm ?? d.rootRadius_R_mm { lines.append("R₁ = \(formatVal(r1)) mm") }
            if let r2 = d.toeRadius_r_mm { lines.append("R₂ = \(formatVal(r2)) mm") }
            if let ix = st.ixx_cm4 { lines.append("I_x = \(ix) cm⁴") }
            if let iy = st.iyy_cm4 { lines.append("I_y = \(iy) cm⁴") }
            if let rx = st.rxx_cm { lines.append("r_x = \(rx) cm") }
            if let ry = st.ryy_cm { lines.append("r_y = \(ry) cm") }
            if let zx = st.zxx_cm3 { lines.append("Z_x = \(zx) cm³") }
            if let zy = st.zyy_cm3 { lines.append("Z_y = \(zy) cm³") }
        } else if s.family.rawValue.contains("Channels") {
            lines.append("M = \(s.massPerMetre) Kg/m")
            lines.append("Ar = \(s.area) cm²")
            if let h = d.depth_h_mm { lines.append("D = \(formatVal(h)) mm") }
            if let b = d.width_b_mm { lines.append("B = \(formatVal(b)) mm") }
            if let tw = d.webThickness_tw_mm { lines.append("t = \(formatVal(tw)) mm") }
            if let tf = d.flangeThickness_tf_mm { lines.append("T = \(formatVal(tf)) mm") }
            if let r1 = d.rootRadius_r1_mm ?? d.rootRadius_R_mm { lines.append("R₁ = \(formatVal(r1)) mm") }
            if let r2 = d.toeRadius_r_mm { lines.append("R₂ = \(formatVal(r2)) mm") }
            if let cy = st.cy_cm { lines.append("C_y = \(cy) cm") }
            if let ix = st.ixx_cm4 { lines.append("I_x = \(ix) cm⁴") }
            if let iy = st.iyy_cm4 { lines.append("I_y = \(iy) cm⁴") }
            if let rx = st.rxx_cm { lines.append("r_x = \(rx) cm") }
            if let ry = st.ryy_cm { lines.append("r_y = \(ry) cm") }
            if let zx = st.zxx_cm3 { lines.append("Z_x = \(zx) cm³") }
            if let zy = st.zyy_cm3 { lines.append("Z_y = \(zy) cm³") }
        } else if s.family == .flats {
            lines.append("M = \(s.massPerMetre) Kg/m")
            if let t = d.thickness_t_mm { lines.append("t = \(formatVal(t)) mm") }
            if let w = d.width_b_mm { lines.append("w = \(formatVal(w)) mm") }
        } else if s.family == .hrPlates {
            lines.append("M = \(s.massPerMetre) Kg/m²")
            if let t = d.thickness_t_mm { lines.append("t = \(formatVal(t)) mm") }
        } else {
            lines.append("M = \(s.massPerMetre) Kg/m")
            lines.append("Ar = \(s.area) cm²")
            if let s = d.side_s_mm ?? d.diameter_d_mm { lines.append("t = \(formatVal(s)) mm") }
        }

        return lines
    }

    private func formatVal(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", v) : String(format: "%.1f", v)
    }
}
