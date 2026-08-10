import Foundation

/// Safe CSV exporter neutralizing spreadsheet formula injection attacks.
public struct CSVExporter {

    /// Sanitizes any string field so spreadsheet programs (Excel, Numbers) do not execute malicious formulas.
    public static func sanitizeCSVField(_ input: String) -> String {
        var str = input
        let dangerousPrefixes: [Character] = ["=", "+", "-", "@", "\t", "\r"]
        if let first = str.first, dangerousPrefixes.contains(first) {
            str = "'" + str
        }
        if str.contains(",") || str.contains("\"") || str.contains("\n") {
            str = "\"" + str.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return str
    }

    /// Generates CSV content for a list of steel sections.
    public static func exportSectionsToCSV(_ sections: [SteelSection]) -> String {
        var csv = "Designation,Family,Series,Standard,Mass (kg/m),Area (cm²),Depth (mm),Width (mm),Web (mm),Flange (mm),Ix (cm⁴),Iy (cm⁴),rx (cm),ry (cm),Zx (cm³),Zy (cm³)\n"

        for s in sections {
            let desig = sanitizeCSVField(s.designation)
            let fam = sanitizeCSVField(s.family.rawValue)
            let ser = sanitizeCSVField(s.series)
            let std = sanitizeCSVField(s.standard)
            let mass = s.massPerMetre
            let area = s.area
            let depth = s.dimensions.primaryDepth ?? 0
            let width = s.dimensions.primaryWidth ?? 0
            let tw = s.dimensions.webThickness_tw_mm ?? s.dimensions.thickness_t_mm ?? 0
            let tf = s.dimensions.flangeThickness_tf_mm ?? 0
            let ix = s.structural.ixx_cm4 ?? 0
            let iy = s.structural.iyy_cm4 ?? 0
            let rx = s.structural.rxx_cm ?? 0
            let ry = s.structural.ryy_cm ?? 0
            let zx = s.structural.zxx_cm3 ?? 0
            let zy = s.structural.zyy_cm3 ?? 0

            let line = "\(desig),\(fam),\(ser),\(std),\(mass),\(area),\(depth),\(width),\(tw),\(tf),\(ix),\(iy),\(rx),\(ry),\(zx),\(zy)\n"
            csv += line
        }

        return csv
    }
}
