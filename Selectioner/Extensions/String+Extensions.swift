// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension String {
    func padLeft(targetLength: Int, padCharacter: String = " ") -> String {
        guard targetLength > count else { return self }

        return String(repeating: padCharacter, count: targetLength - count) + self
    }
}

extension CGPoint: CustomStringConvertible {
    public var description: String {
        "(" + String(format: "%.2f", x) + ", " + String(format: "%.2f", y) + ")"
    }
}

extension CGSize: CustomStringConvertible {
    public var description: String {
        String(format: "%.2f", width) + " x " + String(format: "%.2f", height)
    }
}

extension CGVector: CustomStringConvertible {
    public var description: String {
        "(" + String(format: "%.2f", dx) + ", " + String(format: "%.2f", dy) + ")"
    }
}

func getMousePositionString(positionInView: CGPoint) -> String {
    let vx = String(format: "%.2f", positionInView.x)
    let vy = String(format: "%.2f", positionInView.y)

    return "(\(vx), \(vy))"
}

func getMousePositionString(forScene scene: SpriteWorld.Scene, positionInView: CGPoint) -> String {
    let positionInScene = scene.convertPoint(fromView: positionInView)
    let sx = String(format: "%.2f", positionInScene.x)
    let sy = String(format: "%.2f", positionInScene.y)

    return "(\(sx), \(sy))"
}
