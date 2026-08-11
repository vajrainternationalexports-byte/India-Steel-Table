import SwiftUI

/// Main Dual-App Container View hosting:
/// - Project A: IS Steel Table
/// - Project B: Engineering Weight Calculator
/// Supports swipe gesture navigation between both apps.
public struct DualAppContainerView: View {
    @State private var selectedTab: Int = 0 // 0: Project A, 1: Project B
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Segmented Header Bar
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedTab = 0
                    }
                }) {
                    HStack {
                        Image(systemName: "ruler.fill")
                        Text("IS Steel Table")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(selectedTab == 0 ? Color(red: 0, green: 0.9, blue: 1) : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == 0 ? Color(red: 0, green: 0.9, blue: 1).opacity(0.15) : Color.clear)
                }
                
                Divider()
                    .frame(height: 20)
                    .background(Color.white.opacity(0.2))
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedTab = 1
                    }
                }) {
                    HStack {
                        Image(systemName: "scalemass.fill")
                        Text("Weight Calculator")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(selectedTab == 1 ? Color(red: 0, green: 0.9, blue: 1) : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == 1 ? Color(red: 0, green: 0.9, blue: 1).opacity(0.15) : Color.clear)
                }
            }
            .background(Color(red: 0.1, green: 0.11, blue: 0.14))
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color(red: 0, green: 0.9, blue: 1)),
                alignment: .bottom
            )
            
            // TabView Container with Horizontal Paging
            TabView(selection: $selectedTab) {
                // Project A: IS Steel Table
                SteelTableAppContainerView()
                    .tag(0)
                
                // Project B: Engineering Weight Calculator
                WeightCalculatorMainView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
