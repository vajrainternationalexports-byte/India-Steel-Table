import XCTest
@testable import ISSteelTablesPro

final class EngineeringCalculationTests: XCTestCase {

    func testSectionMassCalculation() {
        // ISMB 300: 44.2 kg/m, 10 pcs, 6m length -> 10 * 6 * 44.2 = 2652.0 kg
        let (massKg, massTonnes, weightKN) = EngineeringCalculations.calculateSectionTotalMass(
            quantity: 10,
            lengthMeters: 6.0,
            massPerMetreKg: 44.2
        )
        XCTAssertEqual(massKg, 2652.0, accuracy: 0.001)
        XCTAssertEqual(massTonnes, 2.652, accuracy: 0.001)
        XCTAssertEqual(weightKN, (2652.0 * 9.80665) / 1000.0, accuracy: 0.01)
    }

    func testPlateMassCalculation() {
        // Plate: 2.0m x 1.0m x 10mm -> Volume = 2 * 1 * 0.01 = 0.02 m3 -> Mass = 0.02 * 7850 = 157.0 kg
        let (unitMass, totalMass, massPerM2, areaM2) = EngineeringCalculations.calculatePlateMass(
            lengthMeters: 2.0,
            widthMeters: 1.0,
            thicknessMm: 10.0,
            quantity: 3
        )
        XCTAssertEqual(unitMass, 157.0, accuracy: 0.01)
        XCTAssertEqual(totalMass, 471.0, accuracy: 0.01)
        XCTAssertEqual(massPerM2, 78.5, accuracy: 0.01)
        XCTAssertEqual(areaM2, 2.0, accuracy: 0.001)
    }

    func testRoundBarMassAndRule162() {
        // Round Bar 16mm: Area = pi * 8^2 = 201.06 mm2 -> 2.0106 cm2 -> 2.0106 * 0.785 = 1.578 kg/m
        // Rule 162: 16^2 / 162 = 256 / 162 = 1.580 kg/m
        let (massPerM, totalMass, _, rule162) = EngineeringCalculations.calculateRoundBarMass(
            diameterMm: 16.0,
            lengthMeters: 10.0,
            quantity: 1
        )
        XCTAssertEqual(massPerM, 1.578, accuracy: 0.01)
        XCTAssertEqual(rule162, 1.580, accuracy: 0.01)
        XCTAssertEqual(totalMass, massPerM * 10.0, accuracy: 0.01)
    }

    func testCircularPipeMass() {
        // 50 NB Light Pipe (IS 1161): OD = 60.3mm, t = 2.9mm -> ~4.08 kg/m
        let (massPerM, _, areaCm2, _) = EngineeringCalculations.calculateCircularPipeMass(
            outerDiameterMm: 60.3,
            wallThicknessMm: 2.9,
            lengthMeters: 6.0,
            quantity: 1
        )
        XCTAssertEqual(massPerM, 4.10, accuracy: 0.1)
        XCTAssertGreaterThan(areaCm2, 5.0)
    }

    func testUnitConversions() {
        // 1000 mm -> 1.0 m
        let m = UnitConverter.convertLength(value: 1000, from: .millimeter, to: .meter)
        XCTAssertEqual(m, 1.0, accuracy: 0.0001)

        // 1000 kg -> 1.0 tonne
        let t = UnitConverter.convertMass(value: 1000, from: .kilogram, to: .tonne)
        XCTAssertEqual(t, 1.0, accuracy: 0.0001)

        // 1 kN -> 1000 N
        let n = UnitConverter.convertForce(value: 1, from: .kilonewton, to: .newton)
        XCTAssertEqual(n, 1000.0, accuracy: 0.0001)
    }
}
