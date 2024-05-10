// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

let spriteWorld = SpriteWorld()

@main
struct SelectionerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spriteWorld)
        }
    }
}
