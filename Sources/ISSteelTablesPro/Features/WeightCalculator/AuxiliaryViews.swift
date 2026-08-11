import SwiftUI

// 2D Cross Section Drawing View in SwiftUI
public struct ShapeCanvasView: View {
    public let shape: SectionShapeType
    
    public var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            let center = CGPoint(x: w / 2, y: h / 2)
            
            var path = Path()
            
            switch shape {
            case .box, .flat:
                let rectW = w * 0.45
                let rectH = h * 0.45
                let rect = CGRect(x: center.x - rectW/2, y: center.y - rectH/2, width: rectW, height: rectH)
                path.addRect(rect)
                if shape == .box {
                    let inner = rect.insetBy(dx: 8, dy: 8)
                    path.addRect(inner)
                }
            case .pipe, .rod:
                let radius = min(w, h) * 0.25
                path.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius*2, height: radius*2))
                if shape == .pipe {
                    let innerR = radius * 0.65
                    path.addEllipse(in: CGRect(x: center.x - innerR, y: center.y - innerR, width: innerR*2, height: innerR*2))
                }
            case .channel:
                let cw = w * 0.35
                let ch = h * 0.5
                let x = center.x - cw/2
                let y = center.y - ch/2
                path.move(to: CGPoint(x: x + cw, y: y))
                path.addLine(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x, y: y + ch))
                path.addLine(to: CGPoint(x: x + cw, y: y + ch))
                path.addLine(to: CGPoint(x: x + cw, y: y + ch - 8))
                path.addLine(to: CGPoint(x: x + 8, y: y + ch - 8))
                path.addLine(to: CGPoint(x: x + 8, y: y + 8))
                path.addLine(to: CGPoint(x: x + cw, y: y + 8))
                path.closeSubpath()
            case .angle:
                let aw = w * 0.35
                let ah = h * 0.45
                let x = center.x - aw/2
                let y = center.y - ah/2
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + 8, y: y))
                path.addLine(to: CGPoint(x: x + 8, y: y + ah - 8))
                path.addLine(to: CGPoint(x: x + aw, y: y + ah - 8))
                path.addLine(to: CGPoint(x: x + aw, y: y + ah))
                path.addLine(to: CGPoint(x: x, y: y + ah))
                path.closeSubpath()
            case .beam:
                let bw = w * 0.4
                let bh = h * 0.5
                let x = center.x - bw/2
                let y = center.y - bh/2
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + bw, y: y))
                path.addLine(to: CGPoint(x: x + bw, y: y + 8))
                path.addLine(to: CGPoint(x: center.x + 4, y: y + 8))
                path.addLine(to: CGPoint(x: center.x + 4, y: y + bh - 8))
                path.addLine(to: CGPoint(x: x + bw, y: y + bh - 8))
                path.addLine(to: CGPoint(x: x + bw, y: y + bh))
                path.addLine(to: CGPoint(x: x, y: y + bh))
                path.addLine(to: CGPoint(x: x, y: y + bh - 8))
                path.addLine(to: CGPoint(x: center.x - 4, y: y + bh - 8))
                path.addLine(to: CGPoint(x: center.x - 4, y: y + 8))
                path.addLine(to: CGPoint(x: x, y: y + 8))
                path.closeSubpath()
            case .zsection:
                let zw = w * 0.35
                let zh = h * 0.45
                let x = center.x - zw/2
                let y = center.y - zh/2
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + zw, y: y))
                path.addLine(to: CGPoint(x: x + zw, y: y + zh))
                path.closeSubpath()
            }
            
            ctx.stroke(path, with: .color(Color(red: 0, green: 0.9, blue: 1)), lineWidth: 2)
            ctx.fill(path, with: .color(Color(red: 0, green: 0.9, blue: 1).opacity(0.15)))
        }
        .background(Color(red: 0.1, green: 0.11, blue: 0.14))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// Result Modal View
public struct ResultModalView: View {
    @ObservedObject var viewModel: WeightCalculatorViewModel
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Calculation Result")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.top)
            
            if let res = viewModel.lastResult {
                VStack(spacing: 10) {
                    ResultRow(label: "Component", val: res.component, isCyan: false, isYellow: false)
                    ResultRow(label: "Size", val: res.size, isCyan: false, isYellow: false)
                    ResultRow(label: "Quantity", val: "\(res.quantity)", isCyan: false, isYellow: false)
                    ResultRow(label: "Unit Mass", val: String(format: "%.4f kg", res.unitMassKg), isCyan: true, isYellow: false)
                    ResultRow(label: "Total Mass", val: String(format: "%.4f kg", res.totalMassKg), isCyan: true, isYellow: false)
                    ResultRow(label: "Price Rs./kg", val: String(format: "%.2f", res.pricePerKg), isCyan: false, isYellow: false)
                    ResultRow(label: "Total Cost", val: String(format: "Rs. %.2f", res.totalCost), isCyan: false, isYellow: true)
                }
                .padding()
                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                .cornerRadius(12)
            }
            
            HStack(spacing: 12) {
                Button("+ List") {
                    viewModel.addCurrentToTakeoff()
                    dismiss()
                }
                .font(.system(size: 15, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0, green: 0.9, blue: 1))
                .foregroundColor(.black)
                .cornerRadius(8)
                
                Button("Cancel") {
                    dismiss()
                }
                .font(.system(size: 15, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.08, green: 0.09, blue: 0.12).ignoresSafeArea())
    }
}

struct ResultRow: View {
    let label: String
    let val: String
    let isCyan: Bool
    let isYellow: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 13))
            Spacer()
            Text(val)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isCyan ? Color(red: 0, green: 0.9, blue: 1) : (isYellow ? Color.yellow : .white))
        }
    }
}

// SG Selection View
public struct SGSelectionView: View {
    @ObservedObject var viewModel: WeightCalculatorViewModel
    @Environment(\.dismiss) var dismiss
    
    let densities: [(String, Double)] = [
        ("Steel", 7.85),
        ("Stainless Steel (304/316)", 7.93),
        ("Aluminium", 2.70),
        ("Brass", 8.45),
        ("Bronze", 8.73),
        ("Cast Iron", 7.20),
        ("Copper", 8.96),
        ("Lead", 11.35),
        ("Titanium", 4.51),
        ("Zinc", 7.14),
        ("Gold", 19.32),
        ("Silver", 10.49)
    ]
    
    public var body: some View {
        NavigationView {
            List(densities, id: \.0) { mat in
                Button(action: {
                    viewModel.selectedMaterialName = mat.0
                    viewModel.sgText = String(format: "%.2f", mat.1)
                    dismiss()
                }) {
                    HStack {
                        Text(mat.0)
                            .foregroundColor(.white)
                        Spacer()
                        Text("SG => \(String(format: "%.2f", mat.1))")
                            .font(.system(size: 12, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(red: 0, green: 0.9, blue: 1))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
                .listRowBackground(Color(red: 0.12, green: 0.14, blue: 0.18))
            }
            .navigationTitle("Select Specific Gravity")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

// SWG Selection View
public struct SWGSelectionView: View {
    @ObservedObject var viewModel: WeightCalculatorViewModel
    @Environment(\.dismiss) var dismiss
    
    let swgList: [(String, Double)] = [
        ("8G", 4.064), ("10G", 3.251), ("12G", 2.642), ("14G", 2.032),
        ("16G", 1.626), ("18G", 1.219), ("20G", 0.914), ("22G", 0.711),
        ("24G", 0.559), ("26G", 0.457), ("28G", 0.376)
    ]
    
    public var body: some View {
        NavigationView {
            List(swgList, id: \.0) { swg in
                Button(action: {
                    viewModel.valT = String(format: "%.3f", swg.1)
                    dismiss()
                }) {
                    HStack {
                        Text("British Gauge \(swg.0)")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(String(format: "%.3f", swg.1)) mm")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                    }
                }
                .listRowBackground(Color(red: 0.12, green: 0.14, blue: 0.18))
            }
            .navigationTitle("British Wire Gauge (SWG)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

// Inch Fractions View
public struct InchFractionsView: View {
    let fractions: [(String, Double, Double)] = [
        ("1/64", 0.0156, 0.397), ("1/32", 0.0313, 0.794), ("1/16", 0.0625, 1.588),
        ("1/8", 0.1250, 3.175), ("1/4", 0.2500, 6.350), ("3/8", 0.3750, 9.525),
        ("1/2", 0.5000, 12.700), ("5/8", 0.6250, 15.875), ("3/4", 0.7500, 19.050),
        ("7/8", 0.8750, 22.225), ("1\"", 1.0000, 25.400)
    ]
    
    public var body: some View {
        NavigationView {
            List(fractions, id: \.0) { frac in
                HStack {
                    Text(frac.0)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, alignment: .leading)
                    Spacer()
                    Text(String(format: "%.4f\"", frac.1))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(format: "%.3f mm", frac.2))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                }
                .listRowBackground(Color(red: 0.12, green: 0.14, blue: 0.18))
            }
            .navigationTitle("Inch Fractions Lookup")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

// Takeoff List View
public struct TakeoffListView: View {
    @ObservedObject var viewModel: WeightCalculatorViewModel
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.takeoffList.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No items in takeoff list")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.takeoffList) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.component)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(item.size)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(String(format: "%.3f kg", item.totalMassKg))
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                                    Text(String(format: "Rs. %.2f", item.totalCost))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.yellow)
                                }
                            }
                            .listRowBackground(Color(red: 0.12, green: 0.14, blue: 0.18))
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { idx in
                                viewModel.takeoffList.remove(at: idx)
                            }
                        }
                    }
                    
                    VStack(spacing: 8) {
                        let totalMass = viewModel.takeoffList.reduce(0) { $0 + $1.totalMassKg }
                        let totalCost = viewModel.takeoffList.reduce(0) { $0 + $1.totalCost }
                        
                        HStack {
                            Text("Total Takeoff Mass:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(String(format: "%.4f kg", totalMass))
                                .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text("Total Takeoff Cost:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(String(format: "Rs. %.2f", totalCost))
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.17, blue: 0.22))
                }
            }
            .navigationTitle("Saved Takeoff List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
