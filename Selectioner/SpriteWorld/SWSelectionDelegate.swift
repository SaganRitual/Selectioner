// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension SpriteWorld {

    class SWSelectionDelegate: SelectionerDelegate {
        let scene: SpriteWorld.SWScene
        let selectionBox: SpriteWorld.SWSelectionBox

        init(scene: SpriteWorld.SWScene, selectionBox: SpriteWorld.SWSelectionBox) {
            self.scene = scene
            self.selectionBox = selectionBox
        }

        func drag(_ objects: [Selectable], startVertex: CGPoint, endVertex: CGPoint) {
            selectionBox.drawRubberBand(from: startVertex, to: endVertex)
        }

        func dragEnd() {
            selectionBox.reset()
        }

        func getObject(at positionInView: CGPoint) -> (any Selectable)? {
            var positionInScene = scene.convertPoint(fromView: positionInView)
            positionInScene.y *= -1

            return scene.rootNode.nodes(at: positionInScene).first as? SWGremlin
        }

        func getObjects(in rectangle: CGRect) -> [any Selectable] {
            scene.rootNode.children.compactMap {
                guard let gremlin = $0 as? SpriteWorld.SWGremlin else { return nil }

                return rectangle.contains(gremlin.position) ? gremlin : nil
            }
        }

        func select(_ object: Selectable, yesSelect: Bool = true) {
            scene.select(object, yesSelect: yesSelect)
        }

        func tap(at position: CGPoint) {
            scene.addGremlin(at: position)
        }

    }

}
