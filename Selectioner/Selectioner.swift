// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

protocol Selectable: AnyObject {
    var isSelected: Bool { get set }
}

protocol SelectionDelegate: AnyObject {
    func drag(startVertex: CGPoint, endVertex: CGPoint, shiftKey: Bool)
    func dragEnd(startVertex: CGPoint, endVertex: CGPoint, shiftKey: Bool)

    func tap(at position: CGPoint, shiftKey: Bool)
}
