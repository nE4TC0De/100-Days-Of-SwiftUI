//
//  ContentView.swift
//  DrawingChallenge
//
//  Created by Ryan Park on 2/8/21.
//

import SwiftUI

struct ContentView: View {
    @State private var insetAmount: CGFloat = 10
    @State private var colorCycle = 0.0
    
    var body: some View {
        Arrow(insetAmount: insetAmount)
            .stroke(Color.green, style: StrokeStyle(lineWidth: insetAmount, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
            .onTapGesture {
                withAnimation {
                    self.insetAmount = CGFloat.random(in: 10...30)
                }
            }
        VStack {
            ColorCyclingRectangle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
}

struct Arrow: Shape {
    var insetAmount: CGFloat
    var rectangleWidth: CGFloat = 40
    var triangleBase: CGFloat = 150

    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX - (rectangleWidth / 2), y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + (rectangleWidth / 2), y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + (rectangleWidth / 2), y: rect.midY))

        path.addLine(to: CGPoint(x: rect.midX + (triangleBase / 2), y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - (triangleBase / 2), y: rect.midY))

        path.addLine(to: CGPoint(x: rect.midX - (rectangleWidth / 2), y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - (rectangleWidth / 2), y: rect.maxY))
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
