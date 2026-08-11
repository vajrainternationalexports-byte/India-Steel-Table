import SwiftUI

/// Main View for Project B: Engineering Weight Calculator
public struct WeightCalculatorMainView: View {
    @StateObject private var viewModel = WeightCalculatorViewModel()
    @State private var showingForm = false
    @State private var showingSGModal = false
    @State private var showingSWGModal = false
    @State private var showingFractionsModal = false
    @State private var showingTakeoffModal = false
    @State private var showingResultModal = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.08, blue: 0.10)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !showingForm {
                    // Main Grid Launcher
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Structural Cross Sections")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                                .padding(.horizontal)
                                .padding(.top, 12)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                GridTileView(title: "Rectangular Tube", icon: "square.on.square", isCyan: true) {
                                    viewModel.selectShape(.box)
                                    showingForm = true
                                }
                                GridTileView(title: "Round Pipe", icon: "circle", isCyan: true) {
                                    viewModel.selectShape(.pipe)
                                    showingForm = true
                                }
                                GridTileView(title: "Channel", icon: "square.split.1x2", isCyan: true) {
                                    viewModel.selectShape(.channel)
                                    showingForm = true
                                }
                                GridTileView(title: "Angle", icon: "chevron.right", isCyan: true) {
                                    viewModel.selectShape(.angle)
                                    showingForm = true
                                }
                                GridTileView(title: "Flat / Plate", icon: "rectangle", isCyan: true) {
                                    viewModel.selectShape(.flat)
                                    showingForm = true
                                }
                                GridTileView(title: "Round Bar", icon: "circle.fill", isCyan: true) {
                                    viewModel.selectShape(.rod)
                                    showingForm = true
                                }
                                GridTileView(title: "Beam", icon: "h.square", isCyan: true) {
                                    viewModel.selectShape(.beam)
                                    showingForm = true
                                }
                                GridTileView(title: "Z-Section", icon: "z.square", isCyan: true) {
                                    viewModel.selectShape(.zsection)
                                    showingForm = true
                                }
                            }
                            .padding(.horizontal)
                            
                            Text("Engineering Utilities")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.orange)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                GridTileView(title: "Inch Fractions", icon: "ruler", isCyan: false) {
                                    showingFractionsModal = true
                                }
                                GridTileView(title: "Display List (\(viewModel.takeoffList.count))", icon: "list.bullet.clipboard", isCyan: false) {
                                    showingTakeoffModal = true
                                }
                                GridTileView(title: "Specific Gravity", icon: "testtube.2", isCyan: false) {
                                    showingSGModal = true
                                }
                                GridTileView(title: "SWG Gauges", icon: "gearshape", isCyan: false) {
                                    showingSWGModal = true
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                } else {
                    // Form Screen
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: { showingForm = false }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                            }
                            Spacer()
                            Text(viewModel.activeShape.title)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.13, blue: 0.17))
                        
                        ScrollView {
                            VStack(spacing: 16) {
                                // 2D Shape Preview Canvas
                                ShapeCanvasView(shape: viewModel.activeShape)
                                    .frame(height: 140)
                                    .padding(.horizontal)
                                    .padding(.top, 8)
                                
                                // Input Fields
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.activeShape.inputFields, id: \.self) { fieldKey in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(fieldKey.label)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.gray)
                                            TextField("", text: bindingForField(fieldKey.key))
                                                .keyboardType(.decimalPad)
                                                .padding(10)
                                                .background(Color(red: 0.14, green: 0.15, blue: 0.20))
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    // Specific Gravity Picker Row
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Specific Gravity")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.gray)
                                        HStack {
                                            TextField("", text: $viewModel.sgText)
                                                .keyboardType(.decimalPad)
                                                .padding(10)
                                                .background(Color(red: 0.14, green: 0.15, blue: 0.20))
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                            
                                            Button("Select") {
                                                showingSGModal = true
                                            }
                                            .font(.system(size: 13, weight: .bold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(Color(red: 0, green: 0.9, blue: 1))
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                        }
                                        Text("\(viewModel.selectedMaterialName) => \(viewModel.sgText)")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(Color(red: 0, green: 0.9, blue: 1))
                                    }
                                    
                                    // Quantity & Price
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Quantity")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.gray)
                                            TextField("", text: $viewModel.quantityText)
                                                .keyboardType(.numberPad)
                                                .padding(10)
                                                .background(Color(red: 0.14, green: 0.15, blue: 0.20))
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Price Rs./kg")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.gray)
                                            TextField("", text: $viewModel.priceText)
                                                .keyboardType(.decimalPad)
                                                .padding(10)
                                                .background(Color(red: 0.14, green: 0.15, blue: 0.20))
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Calculate Button
                                Button(action: {
                                    viewModel.calculateMass()
                                    showingResultModal = true
                                }) {
                                    Text("Calculate Mass")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(LinearGradient(colors: [Color(red: 0, green: 0.9, blue: 1), Color(red: 0, green: 0.6, blue: 0.8)], startPoint: .top, endPoint: .bottom))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingSGModal) {
            SGSelectionView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingSWGModal) {
            SWGSelectionView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingFractionsModal) {
            InchFractionsView()
        }
        .sheet(isPresented: $showingTakeoffModal) {
            TakeoffListView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingResultModal) {
            ResultModalView(viewModel: viewModel)
        }
    }
    
    private func bindingForField(_ key: String) -> Binding<String> {
        switch key {
        case "h": return $viewModel.valH
        case "w": return $viewModel.valW
        case "t": return $viewModel.valT
        case "l": return $viewModel.valL
        case "od": return $viewModel.valOD
        case "tw": return $viewModel.valTw
        case "tf": return $viewModel.valTf
        case "a": return $viewModel.valA
        case "b": return $viewModel.valB
        case "d": return $viewModel.valD
        case "c": return $viewModel.valC
        default: return $viewModel.valL
        }
    }
}

// Tile View Helper
struct GridTileView: View {
    let title: String
    let icon: String
    let isCyan: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isCyan ? .black : .white)
                    .frame(width: 50, height: 50)
                    .background(isCyan ? Color(red: 0, green: 0.9, blue: 1) : Color.orange)
                    .cornerRadius(12)
                
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(red: 0.12, green: 0.14, blue: 0.18))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
