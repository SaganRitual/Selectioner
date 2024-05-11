// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension SpriteWorld {

    class SWSelectionDelegate: SelectionStateDelegate {
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

        func getObject(at position: CGPoint) -> Gremlin? {
            nil
        }

        func getObjects(in rectangle: CGRect) -> [Gremlin] {
            []
        }

        func select(_ object: Selectable, yesSelect: Bool = false) {

        }

        func tap(at position: CGPoint) {
            scene.addGremlin(at: position)
        }

    }

}
