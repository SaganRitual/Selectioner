#  Selectioner

Coordinate mouse clicking and dragging from SwiftUI to SpriteKit. Works
more-or-less like one might expect:

- Click SpriteView canvas to create a gremlin
- Click a gremlin to select it, deselecting anything else already selected 
- Drag-select multiple gremlins, deselecting anything else not in the box
- Drag a gremlin to move it and all selected gremlins
- Shift-click a gremlin to toggle its selection state without affecting others
- Shift-drag-select to toggle state of gremlins in box without affecting others
