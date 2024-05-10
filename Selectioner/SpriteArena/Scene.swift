// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension SpriteWorld {

    final class Scene: SKScene {
        override func didMove(to view: SKView) {
            scaleMode = .resizeFill
            backgroundColor = .black
        }
    }

}
