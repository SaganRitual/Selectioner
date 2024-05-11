// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct ContentView: View {
    @ObservedObject private var appState = AppState()

    // With eternal gratitude to
    // https://forums.developer.apple.com/forums/profile/billh04
    // Adding a nearly invisible view to make DragGesture() respond
    // https://forums.developer.apple.com/forums/thread/724082
    let glassPaneColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.01)

    @State private var hoverLocation: CGPoint?
    @State private var viewSize: CGSize = .zero

    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                SpriteView(
                    scene: appState.scene,
                    debugOptions: [.showsFPS, .showsNodeCount]
                )
                
                Color(cgColor: glassPaneColor)
                    .background() {
                        GeometryReader { geometry in
                            Path { _ in
                                DispatchQueue.main.async {
                                    if self.viewSize != geometry.size {
                                        self.viewSize = geometry.size
                                    }
                                }
                            }
                        }
                    }
            }

            .gesture(
                DragGesture().modifiers(.shift)
                    .onChanged { value in
                        hoverLocation = value.location
                        appState.selectioner.drag(startVertex: value.startLocation, endVertex: value.location, shiftKey: true)
                    }
                    .onEnded { value in
                        hoverLocation = value.location
                        appState.selectioner.dragEnd(startVertex: value.startLocation, endVertex: value.location, shiftKey: true)
                    }
            )

            .gesture(
                DragGesture()
                    .onChanged { value in
                        hoverLocation = value.location
                        appState.selectioner.drag(startVertex: value.startLocation, endVertex: value.location)
                    }
                    .onEnded { value in
                        hoverLocation = value.location
                        appState.selectioner.dragEnd(startVertex: value.startLocation, endVertex: value.location)
                    }
            )

            .gesture(
                TapGesture().modifiers(.shift).onEnded {
                    appState.selectioner.tap(at: hoverLocation!, shiftKey: true)
                }
            )

            .gesture(
                TapGesture().onEnded {
                    appState.selectioner.tap(at: hoverLocation!, shiftKey: false)
                }
            )

            // With eternal gratitude to Natalia Panferova
            // Using .onContinuousHover to track mouse position
            // https://nilcoalescing.com/blog/TrackingHoverLocationInSwiftUI/
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    hoverLocation = location
                case .ended:
                    hoverLocation = nil
                }
            }

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("SKVisycs")
                    Spacer()
                }
                .padding(.bottom)
                
                HStack {
                    Spacer()
                    Text("Size").underline()
                    Spacer()
                }
                .padding(.bottom)
                
                HStack {
                    Text("View/Scene")
                    Spacer()
                    Text("\(viewSize)")
                }
                .padding(.bottom)

                HStack {
                    Spacer()
                    Text("Mouse").underline()
                    Spacer()
                }
                .padding(.bottom)

                if hoverLocation == nil {
                    Text("N/A")
                        .padding(.bottom, 10 + 16)
                } else {
                    HStack {
                        Text("SwiftUI View")
                        Spacer()
                        Text("\(hoverLocation!)")
                    }

                    HStack {
                        Text("SpriteKit Scene")
                        Spacer()
                        Text("\(appState.scene.convertPoint(fromView: hoverLocation!))")
                    }
                    .padding(.bottom, 10)
                }
            }
            .monospaced()
            .frame(width: 300)
        }
    }
}

#Preview {
    ContentView()
}
