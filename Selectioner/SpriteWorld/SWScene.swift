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

        let selectionDelegate: SWSelectionDelegate

        init(selectionDelegate: SWSelectionDelegate) {
            self.selectionDelegate = selectionDelegate

            // Haven't yet figured out why super.init() causes an exception that
            // says Fatal error: Use of unimplemented initializer 'init(size:)' for class 'Selectioner.SWScene'
            // Fortunately we can just start with a size of .zero and let SwiftUI set our size later
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

        let gremlin = SpriteWorld.SWGremlin(imageNamed: spriteNames[coin])

        gremlin.position = convertPoint(fromView: position)

        // I still haven't figured this part out; for some reason, SpriteKit's
        // y-coordinates are inverted relative to the SwiftUI coordinate spaces
        gremlin.position.y *= -1

        rootNode.addChild(gremlin)

        // Make the selection indicator slightly larger than the gremlin,
        // so we can put it behind the gremlin (to simplify click detection) and
        // still see it
        let simpleSelectionShape = SKShapeNode(circleOfRadius: 1.05 * (gremlin.size.height / 2))
        simpleSelectionShape.name = "SelectionIndicator"
        simpleSelectionShape.lineWidth = 1
        simpleSelectionShape.strokeColor = .white
        simpleSelectionShape.fillColor = .clear
        simpleSelectionShape.blendMode = .replace
        simpleSelectionShape.isHidden = true
        simpleSelectionShape.zPosition = gremlin.zPosition - 1

        gremlin.addChild(simpleSelectionShape)
    }

    func drag(_ objects: [Selectable], startVertex: CGPoint, endVertex: CGPoint) {
        objects.forEach {
            let gremlin = $0 as! SpriteWorld.SWGremlin

            var sv = convertPoint(fromView: startVertex)
            var ev = convertPoint(fromView: endVertex)

            sv.y *= -1
            ev.y *= -1

            if gremlin.startDragPosition == nil {
                gremlin.startDragPosition = gremlin.position
            }

            gremlin.position.x = gremlin.startDragPosition!.x + ev.x - sv.x
            gremlin.position.y = gremlin.startDragPosition!.y + ev.y - sv.y
        }
    }

    func dragEnd(_ objects: [any Selectable]) {
        objects.forEach {
            let gremlin = $0 as! SpriteWorld.SWGremlin
            gremlin.startDragPosition = nil
        }
    }

    func select(_ object: Selectable, yesSelect: Bool = true) {
        (object as! SpriteWorld.SWGremlin).childNode(withName: "SelectionIndicator")!.isHidden = !yesSelect
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

        selectionDelegate.postInit(scene: self, selectionBox: selectionBox)
    }

}

