import SwiftUI

/// Screen 4: Calculator View matching Android IS Steel Table v1.4.3 Screenshot 9.
public struct ReplicaCalculatorView: View {
    public let section: SteelSection

    @State private var activeField: CalcField = .rate
    @State private var lengthVal: String = "1"
    @State private var rateVal: String = ""

    public enum CalcField {
        case length
        case rate
    }

    public init(section: SteelSection) {
        self.section = section
    }

    public var body: some View {
        let lenNum = Double(lengthVal) ?? 0
        let rateNum = Double(rateVal) ?? 0
        let totalWeightKg = lenNum * section.massPerMetre
        let totalPrice = rateNum > 0 ? (totalWeightKg * rateNum) : nil

        VStack(spacing: 0) {
            // Display Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Total Weight: \(String(format: "%.1f", totalWeightKg)) Kg")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                Text("Total Price: \(totalPrice != nil ? String(format: "₹ %.2f", totalPrice!) : "")")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                // Length Row
                Button {
                    activeField = .length
                } label: {
                    HStack {
                        Text("Length (in meter)")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        Spacer()
                        Text(lengthVal)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(activeField == .length ? Color.blue.opacity(0.4) : Color.black.opacity(0.3))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(activeField == .length ? Color.cyan : Color.gray, lineWidth: 1)
                            )
                    }
                }
                .buttonStyle(.plain)

                // Rate Row
                Button {
                    activeField = .rate
                } label: {
                    HStack {
                        Text("Rate (in ₹/kg)")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        Spacer()
                        Text(rateVal.isEmpty ? "Enter rate" : rateVal)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(rateVal.isEmpty ? .gray : .white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(activeField == .rate ? Color.blue.opacity(0.4) : Color.black.opacity(0.3))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(activeField == .rate ? Color.cyan : Color.gray, lineWidth: 1)
                            )
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(Color(red: 0.18, green: 0.19, blue: 0.22))

            Spacer()

            // 7x3 Keypad Grid
            let keys: [[(label: String, action: KeyAction, red: Bool)]] = [
                [
                    ("⬆", .up, false), ("⇤", .tabPrev, false), ("1", .num("1"), false),
                    ("2", .num("2"), false), ("3", .num("3"), false), ("⇥", .tabNext, false),
                    ("⌫", .backspace, true)
                ],
                [
                    ("/", .num("/"), false), ("*", .num("*"), false), ("4", .num("4"), false),
                    ("5", .num("5"), false), ("6", .num("6"), false), ("+", .num("+"), false),
                    ("-", .num("-"), false)
                ],
                [
                    ("⬇", .down, false), (".", .num("."), false), ("7", .num("7"), false),
                    ("8", .num("8"), false), ("9", .num("9"), false), ("0", .num("0"), false),
                    ("=", .calc, false)
                ]
            ]

            VStack(spacing: 4) {
                ForEach(0..<keys.count, id: \.self) { rowIndex in
                    HStack(spacing: 4) {
                        ForEach(0..<keys[rowIndex].count, id: \.self) { colIndex in
                            let k = keys[rowIndex][colIndex]
                            Button {
                                handlePress(k.action)
                            } label: {
                                Text(k.label)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(k.red ? Color.red.opacity(0.8) : Color(red: 0.28, green: 0.30, blue: 0.33))
                                    .cornerRadius(4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(6)
            .frame(height: 220)
            .background(Color(red: 0.11, green: 0.12, blue: 0.14))
        }
        .background(Color(red: 0.13, green: 0.14, blue: 0.16))
        .navigationTitle("\(section.family.rawValue) \(cleanDesignation(section))")
        .navigationBarTitleDisplayMode(.inline)
    }

    public enum KeyAction {
        case num(String)
        case backspace
        case up, down, tabPrev, tabNext
        case calc
    }

    private func handlePress(_ action: KeyAction) {
        switch action {
        case .num(let s):
            if activeField == .length {
                lengthVal = (lengthVal == "0" ? "" : lengthVal) + s
            } else {
                rateVal += s
            }
        case .backspace:
            if activeField == .length {
                if !lengthVal.isEmpty { lengthVal.removeLast() }
            } else {
                if !rateVal.isEmpty { rateVal.removeLast() }
            }
        case .up, .tabPrev:
            activeField = .length
        case .down, .tabNext:
            activeField = .rate
        case .calc:
            // Evaluate basic expressions if any
            break
        }
    }

    private func cleanDesignation(_ s: SteelSection) -> String {
        var d = s.designation
        d = d.replacingOccurrences(of: "^ISA\\s+", with: "", options: .regularExpression)
        d = d.replacingOccurrences(of: "^FLAT\\s+", with: "", options: .regularExpression)
        d = d.replacingOccurrences(of: "^PLATE\\s+", with: "", options: .regularExpression)
        return d
    }
}
