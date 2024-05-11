// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension SpriteWorld {

    final class SWGremlin: SKSpriteNode, Selectable {
        var isSelected: Bool = false
        var startDragPosition: CGPoint?
    }

}
