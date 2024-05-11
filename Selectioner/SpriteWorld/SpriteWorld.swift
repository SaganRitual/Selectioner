// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SwiftUI

enum SpriteWorld {

    class WorldState: ObservableObject {
        @Published var scene: SpriteWorld.SWScene
        @Published var select: SelectionState

        init() {
            let select = SelectionState()
            let scene = SpriteWorld.SWScene(selectionState: select)

            self.scene = scene
            self.select = select
        }
    }

}
