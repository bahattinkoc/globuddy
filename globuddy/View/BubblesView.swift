//
//  BubblesView.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 27.11.2024.
//

import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    var size: CGFloat
    var positionX: CGFloat
    var positionY: CGFloat
    var speed: Double
    var opacity: Double
}

struct BubblesView: View {

    // MARK: - PROPERTIES

    @State private var bubbles = [Bubble]()

    var body: some View {
        ZStack {
            ForEach(bubbles.indices, id: \.self) { index in
                Circle()
                    .frame(width: bubbles[index].size, height: bubbles[index].size)
                    .position(x: bubbles[index].positionX, y: bubbles[index].positionY)
                    .opacity(bubbles[index].opacity)
                    .onAppear {
                        animateBubble(at: index)
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: createBubbles)
    }

    // MARK: - PRIVATE FUNCTIONS

    private func createBubbles() {
        for _ in 0..<100 {
            let size = CGFloat.random(in: 5...15)
            let positionX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let positionY = UIScreen.main.bounds.height + size
            let speed = Double.random(in: 15.0...20.0)
            let opacity = Double.random(in: 0.2...0.5)
            let bubble = Bubble(size: size, positionX: positionX, positionY: positionY, speed: speed, opacity: opacity)
            bubbles.append(bubble)
        }
    }

    private func animateBubble(at index: Int) {
        let delay = Double.random(in: 0...20)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeOut(duration: bubbles[index].speed)
                .repeatForever(autoreverses: false)) {
                bubbles[index].positionY = -100
                bubbles[index].opacity = 0
            }
        }
    }
}

#Preview {
    BubblesView()
}
