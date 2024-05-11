// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import GameplayKit
import SpriteKit

final class Gremlin: Selectable {
    var isSelected: Bool = false
}

extension SpriteWorld {
    enum SWComponent { }
    enum SWEntity { }
    enum SWSystem { }
}

extension SpriteWorld.SWComponent {

    final class CMousePosition: GKComponent {

    }

    final class CRubberBand: GKComponent {

    }

}

extension SpriteWorld.SWEntity {

    final class SceneEntity: GKEntity {

    }

}

extension SpriteWorld.SWSystem {

    final class SRubberBand: GKComponentSystem<SpriteWorld.SWComponent.CRubberBand> {

    }

}

extension SpriteWorld {

    final class SWScene: SKScene {
        var cameraScale: CGFloat = 0.2

        let cameraNode = SKCameraNode()
        let rootNode = SKNode()

        let selectionExtentRoot = SKNode()
        var selectionExtentSprites = [SKSpriteNode]()
        var selectionBox: SWSelectionBox!

        var selectionDelegate: SWSelectionDelegate?
        let selectionState: SelectionState

        init(selectionState: SelectionState) {
            self.selectionState = selectionState
            super.init(size: .zero)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMove(to view: SKView) {
            scaleMode = .resizeFill
            backgroundColor = .black

            addChild(rootNode)

            addChild(cameraNode)
            camera = cameraNode

            cameraNode.position = CGPoint.zero
            cameraNode.setScale(cameraScale)

            setupSelectionHandling()
        }
    }

}

extension SpriteWorld.SWScene {
    func addGremlin(at position: CGPoint) {
        let coin = [0, 1, 2, 3].randomElement()!
        let spriteNames = ["spaceman", "flapper", "cyclops", "grouch"]

        let sprite = SKSpriteNode(imageNamed: spriteNames[coin])

        sprite.position = convertPoint(fromView: position)
        sprite.position.y *= -1

        rootNode.addChild(sprite)
    }
}

private extension SpriteWorld.SWScene {

    func setupSelectionHandling() {
        rootNode.addChild(selectionExtentRoot)

        self.selectionExtentSprites = SpriteWorld.SWSelectionBox.Directions.allCases.map { ss in
            let sprite = SKSpriteNode(imageNamed: "pixel_1x1")

            sprite.alpha = 0.7
            sprite.colorBlendFactor = 1
            sprite.color = .yellow
            sprite.isHidden = false
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.size = CGSize(width: 1, height: 1)

            selectionExtentRoot.addChild(sprite)
            return sprite
        }

        selectionBox = SpriteWorld.SWSelectionBox(
            scene: self,
            selectionExtentRoot: selectionExtentRoot,
            selectionExtentSprites: selectionExtentSprites
        )

        selectionState.delegate = SpriteWorld.SWSelectionDelegate(
            scene: self, selectionBox: selectionBox
        )
    }

}

