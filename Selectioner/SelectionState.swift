// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension CGRect {
    init(startVertex: CGPoint, endVertex: CGPoint) {
        self.init(
            origin: startVertex,
            size: CGSize(
                width: abs(endVertex.x - startVertex.x),
                height: abs(endVertex.y - startVertex.y)
            )
        )
    }
}

protocol Selectable: AnyObject {
    var isSelected: Bool { get set }
}

protocol SelectionStateDelegate: AnyObject {
    
}

final class SelectionState {
    var delegate: SpriteWorld.SWSelectionDelegate?
    var selectedObjects = [Selectable]()

    func deselect(_ object: Selectable) {
        assert(selectedObjects.contains { $0 === object })
        select(object, yesSelect: false)
    }

    func deselectAll() {
        let toDeselect = selectedObjects.map { $0 }
        select(toDeselect, yesSelect: false)
    }

    func drag(startVertex: CGPoint, endVertex: CGPoint) {
        delegate?.drag(selectedObjects, startVertex: startVertex, endVertex: endVertex)
    }

    func dragEnd(startVertex: CGPoint, endVertex: CGPoint, shift: Bool = false) {
        defer {
            delegate?.dragEnd()
        }

        let containedObjects = getObjects(in: CGRect.zero)
        if containedObjects.isEmpty {
            deselectAll()
            return
        }

        if shift {
            toggleSelect(containedObjects)
            return
        }

        deselectAll()
        select(containedObjects)
    }

    func getObject(at position: CGPoint) -> Selectable? {
        delegate?.getObject(at: position)
    }

    func getObjects(in rectangle: CGRect) -> [Selectable] {
        delegate?.getObjects(in: rectangle) ?? []
    }

    func tap(at position: CGPoint, shift: Bool = false) {
        guard let tappedObject = getObject(at: position) else {
            deselectAll()
            delegate?.tap(at: position)
            return
        }

        if shift {
            toggleSelect(tappedObject)
            return
        }

        deselectAll()
        select(tappedObject)
    }

    func select(_ object: Selectable, yesSelect: Bool = false) {
        if yesSelect {
            if object.isSelected { return }

            object.isSelected = true
            selectedObjects.append(object)
        } else {
            object.isSelected = false
            selectedObjects.removeAll { $0 === object }
        }

        delegate?.select(object, yesSelect: yesSelect)
    }

    func select(_ objects: [Selectable], yesSelect: Bool = false) {
        objects.forEach { select($0, yesSelect: yesSelect) }
    }

    func toggleSelect(_ object: Selectable) {
        select(object, yesSelect: !object.isSelected)
    }

    func toggleSelect(_ objects: [Selectable]) {
        objects.forEach { toggleSelect($0) }
    }
}
