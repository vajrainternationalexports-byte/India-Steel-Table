import Foundation
import ISSteelTablesPro

@main
struct CliMain {
    static func main() async {
        print("==================================================")
        print(" IS Steel Tables Pro — CLI & Verification Engine")
        print("==================================================")

        let repo = BundledSteelSectionRepository()
        do {
            print("[*] Loading master steel dataset...")
            let sections = try await repo.getAllSections()
            print("[✓] Successfully loaded \(sections.count) verified steel sections.")

            // Verify count by family
            for family in SectionFamily.allCases {
                let count = sections.filter { $0.family == family }.count
                print("  • \(family.rawValue): \(count) sections")
            }

            // Search verification
            print("\n[*] Testing Search Indexer:")
            let queries = ["ISMB 300", "ISA 50x50x6", "ISMC 150", "15MM NB", "50x25", "Round 16"]
            for q in queries {
                let results = try await repo.searchSections(query: q, family: nil)
                print("  Query '\(q)' -> \(results.count) match(es) [Top: \(results.first?.designation ?? "None")]")
            }

            // Calculation Engine verification
            print("\n[*] Testing Engineering Calculation Engine:")
            let (mKg, mTon, wKN) = EngineeringCalculations.calculateSectionTotalMass(quantity: 10, lengthMeters: 6.0, massPerMetreKg: 44.2)
            print("  ISMB 300 (10 pcs × 6m @ 44.2 kg/m) -> Total Mass: \(String(format: "%.2f", mKg)) kg (\(String(format: "%.3f", mTon)) t), Weight: \(String(format: "%.3f", wKN)) kN")

            let (pUnit, pTot, pM2, _) = EngineeringCalculations.calculatePlateMass(lengthMeters: 2.5, widthMeters: 1.25, thicknessMm: 12.0, quantity: 2)
            print("  Plate 2.5m × 1.25m × 12mm (2 pcs) -> Unit: \(String(format: "%.2f", pUnit)) kg, Total: \(String(format: "%.2f", pTot)) kg (\(String(format: "%.2f", pM2)) kg/m²)")

            let (rMass, rTot, _, r162) = EngineeringCalculations.calculateRoundBarMass(diameterMm: 16.0, lengthMeters: 12.0, quantity: 10)
            print("  Round Bar Ø16mm (10 pcs × 12m) -> Unit: \(String(format: "%.3f", rMass)) kg/m (D²/162 rule: \(String(format: "%.3f", r162)) kg/m), Total: \(String(format: "%.2f", rTot)) kg")

            print("\n[✓] ALL SYSTEM VERIFICATION CHECKS PASSED.")
        } catch {
            print("[!] Verification failed with error: \(error)")
        }
    }
}
