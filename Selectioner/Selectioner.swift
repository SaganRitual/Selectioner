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

protocol UserInputDelegate: AnyObject {
    func drag(startVertex: CGPoint, endVertex: CGPoint, shiftKey: Bool)
    func dragEnd(startVertex: CGPoint, endVertex: CGPoint, shiftKey: Bool)

    func tap(at position: CGPoint, shiftKey: Bool)
}
