// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension SpriteWorld {

    class SWSelectionDelegate: UserInputDelegate {
        var scene: SpriteWorld.SWScene!
        var selectionBox: SpriteWorld.SWSelectionBox!

        var isDraggingObjects = false
        var selectedObjects = [SpriteWorld.SWGremlin]()

        func postInit(scene: SpriteWorld.SWScene, selectionBox: SpriteWorld.SWSelectionBox) {
            self.scene = scene
            self.selectionBox = selectionBox
        }

        func drag(startVertex: CGPoint, endVertex: CGPoint, shiftKey: Bool = false) {
            if selectedObjects.isEmpty {
                // If nothing is currently selected, it's a simple drag

                if let toDrag = getObject(at: endVertex) {
                    // If the drag starts on top of an object, we're dragging that object
                    isDraggingObjects = true

                    select(toDrag)
                    scene.drag(selectedObjects, startVertex: startVertex, endVertex: endVertex)
                    return
                }

                // If the drag starts in empty space, we're drawing a selection marquee
                selectionBox.drawRubberBand(from: startVertex, to: endVertex)
                return
            }

            // Something is currently selected

            if let primary = getObject(at: endVertex) {
                // The drag is starting on top of an object

                if primary.isSelected {
                    // If that object is already selected, we're just dragging it and
                    // anything else that's already selected
                    isDraggingObjects = true
                    scene.drag(selectedObjects, startVertex: startVertex, endVertex: endVertex)
                    return
                }

                // The object we're dragging wasn't already selected

                if shiftKey {
                    // Shift-drag; add the object to whatever is already selected and
                    // drag all selected objects
                    isDraggingObjects = true
                    select(primary)
                    scene.drag(selectedObjects, startVertex: startVertex, endVertex: endVertex)
                    return
                }

                // No shift key; deselect everything but the object to be dragged
                deselectAll()

                isDraggingObjects = true
                select(primary)
                scene.drag(selectedObjects, startVertex: startVertex, endVertex: endVertex)
                return

            }

            // The drag is starting over empty space; just draw a selection marquee;
            // we'll deal with shift key and deselection at drag-end
            selectionBox.drawRubberBand(from: startVertex, to: endVertex)
        }

        func dragEnd(startVertex: CGPoint, endVertex: CGPoint, shiftKey: Bool = false) {
            if selectedObjects.isEmpty {
                assert(!isDraggingObjects, "Dragging objects but nothing selected?")

                // Nothing was already selected

                let containedObjects = getObjects(in: CGRect(startVertex: startVertex, endVertex: endVertex))

                if containedObjects.isEmpty {
                    // User stretched a rubber band that ended up with nothing in it; since
                    // there was nothing already selected, there's nothing for us to do
                    return
                }

                // User shift-stretched a rubber band around some selectable items; toggle
                // the selection state of everything that was within the rubber band
                if shiftKey {
                    toggleSelect(containedObjects)
                    return
                }

                // Simple marquee-select around some objects. Since nothing was already
                // selected, we simply select whatever was inside the marqee
                select(containedObjects)
                return
            }

            // Something is currently selected

            if isDraggingObjects {
                // We were dragging objects; no change to selection when we're finished
                return
            }

            // If not dragging anything then we were drawing a selection marquee

            let containedObjects = getObjects(in: CGRect(startVertex: startVertex, endVertex: endVertex))

            if containedObjects.isEmpty {
                // User stretched a rubber band that ended up with nothing in it

                // If shift key was held, we won't change the selection state
                if !shiftKey {
                    deselectAll()
                }

                return
            }

            // User stretched a rubber band around selectable objects

            if shiftKey {
                // If shift key, toggle everything inside the marquee
                toggleSelect(containedObjects)
            } else {
                deselectAll()
                select(containedObjects)
            }
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

        func deselect(_ object: Selectable) {
            assert(selectedObjects.contains { $0 === object })
            select(object, yesSelect: false)
        }

        func deselectAll() {
            let toDeselect = selectedObjects.map { $0 }
            select(toDeselect, yesSelect: false)
        }

        func tap(at position: CGPoint, shiftKey: Bool = false) {
            guard let tappedObject = getObject(at: position) else {
                deselectAll()
                scene.addGremlin(at: position)
                return
            }

            if shiftKey {
                toggleSelect(tappedObject)
                return
            }

            deselectAll()
            select(tappedObject)
        }

        func select(_ object: Selectable, yesSelect: Bool = true) {
            if yesSelect {
                if object.isSelected { return }

                object.isSelected = true
                selectedObjects.append(object as! SpriteWorld.SWGremlin)
            } else {
                object.isSelected = false
                selectedObjects.removeAll { $0 === object }
            }

            scene.select(object, yesSelect: yesSelect)
        }

        func select(_ objects: [Selectable], yesSelect: Bool = true) {
            objects.forEach { select($0, yesSelect: yesSelect) }
        }

        func toggleSelect(_ object: Selectable) {
            select(object, yesSelect: !object.isSelected)
        }

        func toggleSelect(_ objects: [Selectable]) {
            objects.forEach { toggleSelect($0) }
        }

    }

}
