// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var scene: SpriteWorld.SWScene
    @Published var selectioner: SpriteWorld.SWSelectionDelegate

    init() {
        let selectioner = SpriteWorld.SWSelectionDelegate()
        let scene = SpriteWorld.SWScene(selectionDelegate: selectioner)

        self.scene = scene
        self.selectioner = selectioner
    }
}
