import Foundation
import Combine

public enum SectionShapeType: String, CaseIterable {
    case box = "Rectangular Tube"
    case pipe = "Round Pipe"
    case channel = "Channel Section"
    case angle = "Angle Section"
    case flat = "Flat / Plate"
    case rod = "Round Solid Rod"
    case beam = "Beam / I-Section"
    case zsection = "Z-Section"
    
    public var title: String { rawValue }
    
    public struct FieldInfo: Hashable {
        public let key: String
        public let label: String
    }
    
    public var inputFields: [FieldInfo] {
        switch self {
        case .box:
            return [
                FieldInfo(key: "h", label: "Section Height (mm)"),
                FieldInfo(key: "w", label: "Section Width (mm)"),
                FieldInfo(key: "t", label: "Section Thickness (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .pipe:
            return [
                FieldInfo(key: "od", label: "Outer Diameter (OD) (mm)"),
                FieldInfo(key: "t", label: "Wall Thickness (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .channel:
            return [
                FieldInfo(key: "h", label: "Section Height (H) (mm)"),
                FieldInfo(key: "w", label: "Flange Width (B) (mm)"),
                FieldInfo(key: "tw", label: "Web Thickness (tw) (mm)"),
                FieldInfo(key: "tf", label: "Flange Thickness (tf) (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .angle:
            return [
                FieldInfo(key: "a", label: "Leg A (mm)"),
                FieldInfo(key: "b", label: "Leg B (mm)"),
                FieldInfo(key: "t", label: "Thickness (t) (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .flat:
            return [
                FieldInfo(key: "w", label: "Width (mm)"),
                FieldInfo(key: "t", label: "Thickness (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .rod:
            return [
                FieldInfo(key: "d", label: "Diameter (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .beam:
            return [
                FieldInfo(key: "h", label: "Section Height (H) (mm)"),
                FieldInfo(key: "w", label: "Flange Width (B) (mm)"),
                FieldInfo(key: "tw", label: "Web Thickness (tw) (mm)"),
                FieldInfo(key: "tf", label: "Flange Thickness (tf) (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        case .zsection:
            return [
                FieldInfo(key: "h", label: "Height (H) (mm)"),
                FieldInfo(key: "w", label: "Flange (B) (mm)"),
                FieldInfo(key: "c", label: "Lip (C) (mm)"),
                FieldInfo(key: "t", label: "Thickness (t) (mm)"),
                FieldInfo(key: "l", label: "Length (mm)")
            ]
        }
    }
}

public struct TakeoffItem: Identifiable, Codable {
    public var id: UUID = UUID()
    public var component: String
    public var size: String
    public var quantity: Int
    public var unitMassKg: Double
    public var totalMassKg: Double
    public var pricePerKg: Double
    public var totalCost: Double
}

public class WeightCalculatorViewModel: ObservableObject {
    @Published public var activeShape: SectionShapeType = .box
    
    // Inputs
    @Published public var valH: String = "100"
    @Published public var valW: String = "80"
    @Published public var valT: String = "5"
    @Published public var valL: String = "1000"
    @Published public var valOD: String = "114.3"
    @Published public var valTw: String = "5.7"
    @Published public var valTf: String = "7.8"
    @Published public var valA: String = "50"
    @Published public var valB: String = "50"
    @Published public var valD: String = "25"
    @Published public var valC: String = "20"
    
    @Published public var sgText: String = "7.85"
    @Published public var selectedMaterialName: String = "Steel"
    @Published public var quantityText: String = "1"
    @Published public var priceText: String = "1.00"
    
    @Published public var lastResult: TakeoffItem? = nil
    @Published public var takeoffList: [TakeoffItem] = []
    
    public init() {}
    
    public func selectShape(_ shape: SectionShapeType) {
        activeShape = shape
    }
    
    public func calculateMass() {
        let sg = Double(sgText) ?? 7.85
        let qty = Int(quantityText) ?? 1
        let price = Double(priceText) ?? 1.00
        let l = Double(valL) ?? 1000.0
        
        var areaMm2: Double = 0.0
        var sizeLabel: String = ""
        
        switch activeShape {
        case .box:
            let h = Double(valH) ?? 0.0
            let w = Double(valW) ?? 0.0
            let t = Double(valT) ?? 0.0
            areaMm2 = (h * w) - max(0, (h - 2*t) * (w - 2*t))
            sizeLabel = "RHS \(valH)x\(valW)x\(valT)x\(valL)L"
        case .pipe:
            let od = Double(valOD) ?? 0.0
            let t = Double(valT) ?? 0.0
            let id = max(0, od - 2*t)
            areaMm2 = (Double.pi / 4.0) * (od*od - id*id)
            sizeLabel = "PIPE OD\(valOD)x\(valT)x\(valL)L"
        case .channel:
            let h = Double(valH) ?? 0.0
            let w = Double(valW) ?? 0.0
            let tw = Double(valTw) ?? 0.0
            let tf = Double(valTf) ?? 0.0
            areaMm2 = (2 * w * tf) + ((h - 2*tf) * tw)
            sizeLabel = "CHANNEL \(valH)x\(valW)x\(valTw)x\(valTf)x\(valL)L"
        case .angle:
            let a = Double(valA) ?? 0.0
            let b = Double(valB) ?? 0.0
            let t = Double(valT) ?? 0.0
            areaMm2 = (a + b - t) * t
            sizeLabel = "ANGLE \(valA)x\(valB)x\(valT)x\(valL)L"
        case .flat:
            let w = Double(valW) ?? 0.0
            let t = Double(valT) ?? 0.0
            areaMm2 = w * t
            sizeLabel = "FLAT \(valW)x\(valT)x\(valL)L"
        case .rod:
            let d = Double(valD) ?? 0.0
            areaMm2 = (Double.pi / 4.0) * d * d
            sizeLabel = "ROD D\(valD)x\(valL)L"
        case .beam:
            let h = Double(valH) ?? 0.0
            let w = Double(valW) ?? 0.0
            let tw = Double(valTw) ?? 0.0
            let tf = Double(valTf) ?? 0.0
            areaMm2 = (2 * w * tf) + ((h - 2*tf) * tw)
            sizeLabel = "BEAM \(valH)x\(valW)x\(valTw)x\(valTf)x\(valL)L"
        case .zsection:
            let h = Double(valH) ?? 0.0
            let w = Double(valW) ?? 0.0
            let c = Double(valC) ?? 0.0
            let t = Double(valT) ?? 0.0
            areaMm2 = (h + 2*w + 2*c - 4*t) * t
            sizeLabel = "Z \(valH)x\(valW)x\(valC)x\(valT)x\(valL)L"
        }
        
        let unitMass = areaMm2 * l * sg * 1e-6
        let totalMass = unitMass * Double(qty)
        let totalCost = totalMass * price
        
        lastResult = TakeoffItem(
            component: activeShape.title,
            size: sizeLabel,
            quantity: qty,
            unitMassKg: unitMass,
            totalMassKg: totalMass,
            pricePerKg: price,
            totalCost: totalCost
        )
    }
    
    public func addCurrentToTakeoff() {
        if let res = lastResult {
            takeoffList.append(res)
        }
    }
    
    public func removeTakeoff(id: UUID) {
        takeoffList.removeAll { $0.id == id }
    }
}
