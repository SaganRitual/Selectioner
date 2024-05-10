// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SwiftUI

final class SpriteWorld: ObservableObject {

    static let arenaSize = CGSize(width: 100, height: 100)

    @Published var hoverLocation: CGPoint = .zero
    @Published var isHovering = false
    @Published var sceneSize: CGSize = .zero

    let scene: SpriteWorld.Scene

    init() {
        scene = Scene(size: Self.arenaSize)
    }
}
