// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var scene: SpriteWorld.SWScene
    @Published var selectioner: Selectioner

    init() {
        let selectioner = Selectioner()
        let scene = SpriteWorld.SWScene(setSelectionStateDelegate: selectioner.setDelegate)

        self.scene = scene
        self.selectioner = selectioner
    }
}
