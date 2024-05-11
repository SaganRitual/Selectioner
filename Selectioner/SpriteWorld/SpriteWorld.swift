// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SwiftUI

enum SpriteWorld {

    class WorldState: ObservableObject {
        @Published var scene: SpriteWorld.SWScene
        @Published var select: SelectionState

        init() {
            let scene = SpriteWorld.SWScene()
            let select = SelectionState(scene: scene)

            self.scene = scene
            self.select = select
        }
    }

}
