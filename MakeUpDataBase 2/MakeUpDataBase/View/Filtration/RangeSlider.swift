import SwiftUI

// Custom Range Slider for price filtering
struct RangeSlider: View {
    @Binding var value: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    // Add state variables to handle dragging
    @State private var isDraggingLower = false
    @State private var isDraggingUpper = false
    
    init(value: Binding<ClosedRange<Double>>, in bounds: ClosedRange<Double>) {
        self._value = value
        self.bounds = bounds
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(height: 6)
                    .cornerRadius(3)
                
                // Selected range
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: width(for: value, in: geometry), height: 6)
                    .offset(x: offset(for: value.lowerBound, in: bounds, width: geometry.size.width))
                    .cornerRadius(3)
                
                // Lower thumb
                Circle()
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .frame(width: 24, height: 24)
                    .offset(x: offset(for: value.lowerBound, in: bounds, width: geometry.size.width) - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDraggingLower = true
                                let newValue = valueFrom(offset: gesture.location.x, in: geometry)
                                if newValue >= bounds.lowerBound && newValue <= value.upperBound - 1 {
                                    value = newValue...value.upperBound
                                }
                            }
                            .onEnded { _ in
                                isDraggingLower = false
                                // Round to nearest dollar
                                value = Double(Int(value.lowerBound))...value.upperBound
                            }
                    )
                
                // Upper thumb
                Circle()
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .frame(width: 24, height: 24)
                    .offset(x: offset(for: value.upperBound, in: bounds, width: geometry.size.width) - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDraggingUpper = true
                                let newValue = valueFrom(offset: gesture.location.x, in: geometry)
                                if newValue <= bounds.upperBound && newValue >= value.lowerBound + 1 {
                                    value = value.lowerBound...newValue
                                }
                            }
                            .onEnded { _ in
                                isDraggingUpper = false
                                // Round to nearest dollar
                                value = value.lowerBound...Double(Int(value.upperBound))
                            }
                    )
            }
            .frame(height: 30)
            .animation(.interactiveSpring(), value: isDraggingLower)
            .animation(.interactiveSpring(), value: isDraggingUpper)
        }
        .frame(height: 30)
    }
    
    private func offset(for value: Double, in bounds: ClosedRange<Double>, width: CGFloat) -> CGFloat {
        let percent = (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return CGFloat(percent) * width
    }
    
    private func width(for range: ClosedRange<Double>, in geometry: GeometryProxy) -> CGFloat {
        let lowerPercent = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        let upperPercent = (range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        let lowerOffset = max(0, min(1, CGFloat(lowerPercent))) * geometry.size.width
        let upperOffset = max(0, min(1, CGFloat(upperPercent))) * geometry.size.width
        return upperOffset - lowerOffset
    }
    
    private func valueFrom(offset: CGFloat, in geometry: GeometryProxy) -> Double {
        let percent = max(0, min(1, offset / geometry.size.width))
        let value = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(percent)
        return value
    }
}
