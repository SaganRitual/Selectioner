// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var spriteWorld: SpriteWorld

    // With eternal gratitude to
    // https://forums.developer.apple.com/forums/profile/billh04
    // Adding a nearly invisible view to make DragGesture() respond
    // https://forums.developer.apple.com/forums/thread/724082
    let glassPaneColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.01)

    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                SpriteView(
                    scene: spriteWorld.scene,
                    debugOptions: [.showsFPS, .showsPhysics, .showsNodeCount]
                )
                
                Color(cgColor: glassPaneColor)
                    .background() {
                        GeometryReader { geometry in
                            Path { _ in
                                DispatchQueue.main.async {
                                    if spriteWorld.scene.size != geometry.size {
                                        print("\(geometry.size)")
                                        spriteWorld.scene.size = geometry.size
                                    }
                                }
                            }
                        }
                    }
            }

            .gesture(
                DragGesture()
                    .onChanged { value in
                        spriteWorld.hoverLocation = value.location
                        spriteWorld.isHovering = true
                        print("c(\(value.location)")
                    }
                    .onEnded   { value in
                        spriteWorld.hoverLocation = value.location
                        spriteWorld.isHovering = false
                        print("e(\(value.location)")
                    }
            )

            // With eternal gratitude to Natalia Panferova
            // Using .onContinuousHover to track mouse position
            // https://nilcoalescing.com/blog/TrackingHoverLocationInSwiftUI/
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    spriteWorld.hoverLocation = location
                    spriteWorld.isHovering = true
                case .ended:
                    spriteWorld.hoverLocation = .zero
                    spriteWorld.isHovering = false
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
                    Text("Scene/View")
                    Spacer()
                    Text("\(spriteWorld.scene.size)")
                }
                .padding(.bottom)

                HStack {
                    Spacer()
                    Text("Mouse").underline()
                    Spacer()
                }
                .padding(.bottom)

                if spriteWorld.isHovering {
                    HStack {
                        Text("View")
                        Spacer()
                        Text("\(spriteWorld.hoverLocation)")
                    }

                    HStack {
                        Text("Scene")
                        Spacer()
                        Text("\(spriteWorld.hoverLocation)")
                    }
                    .padding(.bottom, 10)
                } else {
                    Text("N/A")
                        .padding(.bottom, 10 + 16)
                }
            }
            .monospaced()
            .frame(width: 300)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SpriteWorld())
}
