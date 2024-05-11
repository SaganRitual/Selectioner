// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import GameplayKit
import SpriteKit

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
        var selectionerView: SelectionerView!

        override func didMove(to view: SKView) {
            scaleMode = .resizeFill
            backgroundColor = .black

            addChild(rootNode)

            addChild(cameraNode)
            camera = cameraNode

            cameraNode.position = CGPoint.zero
            cameraNode.setScale(cameraScale)

            setupSelectionerView()
        }
    }

}

final class Gremlin: Selectable {
    var isSelected: Bool = false
}

extension SpriteWorld.SWScene {

    func drag(_ objects: [Selectable], startVertex: CGPoint, endVertex: CGPoint) {
        selectionerView.drawRubberBand(from: startVertex, to: endVertex)
    }

    func getObject(at position: CGPoint) -> Gremlin? {
        nil
    }

    func getObjects(in rectangle: CGRect) -> [Gremlin] {
        []
    }

    func select(_ object: Selectable, yesSelect: Bool = false) {

    }

    func tap(at position: CGPoint) {
    }

}

private extension SpriteWorld.SWScene {

    func setupSelectionerView() {
        rootNode.addChild(selectionExtentRoot)

        self.selectionExtentSprites = SelectionerView.Directions.allCases.map { ss in
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

        selectionerView = SelectionerView(
            scene: self,
            selectionExtentRoot: selectionExtentRoot,
            selectionExtentSprites: selectionExtentSprites
        )
    }

}

