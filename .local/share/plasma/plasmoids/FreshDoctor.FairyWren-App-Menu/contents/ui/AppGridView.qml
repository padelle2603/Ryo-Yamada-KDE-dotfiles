import QtQuick
import QtQuick.Controls 2.15
import org.kde.kirigami as Kirigami

GridView {
    id: grid
    property bool movedWithKeyboard: false
    property bool movedWithWheel: false
    property bool canMoveWithKeyboard: false
    readonly property int columns: plasmoid.configuration.numberColumns
    focus: true
    clip: true
    currentIndex: count > 0 ? 0 : -1
    interactive: height < contentHeight
    boundsBehavior: Flickable.StopAtBounds
    keyNavigationEnabled: false
    keyNavigationWraps: false
    highlightMoveDuration: 0
    cellWidth: root.cellSizeWidth
    cellHeight: root.cellSizeHeight
    delegate: AppGridViewDelegate {
        id: favitem
        triggerModel: grid.model
    }
    move: normalTransition
    moveDisplaced: normalTransition
    Transition {
        id: normalTransition
        NumberAnimation {
            duration: Kirigami.Units.shortDuration
            properties: "x, y"
            easing.type: Easing.OutCubic
        }
    }
    ScrollBar.vertical: Scrollbar {
        id: verticalScrollBar
        parent: grid
        z: 2
        height: grid.height
        width: 12
        anchors.right: grid.right
        active: grid.movedWithWheel
        }
    Kirigami.WheelHandler {
        id: wheelHandler
        target: grid
        filterMouseEvents: true
        horizontalStepSize: 20 * Qt.styleHints.wheelScrollLines
        verticalStepSize: 20 * Qt.styleHints.wheelScrollLines
            onWheel: wheel => {
            grid.movedWithWheel = true
            grid.movedWithKeyboard = false
            movedWithWheelTimer.restart()
        }
    }
    Connections {
        target: root
        function onVisibleChanged() {
            if (!root.visible) {
                grid.currentIndex = 0
                grid.positionViewAtBeginning()
            }
        }
    }
    Timer {
        id: movedWithKeyboardTimer
        interval: 200
        onTriggered: grid.movedWithKeyboard = false
    }
    Timer {
        id: movedWithWheelTimer
        interval: 200
        onTriggered: grid.movedWithWheel = false
    }
    function focusCurrentItem(event, focusReason) {
        currentItem.forceActiveFocus(focusReason)
        event.accepted = true
    }
    Keys.onPressed: event => {
        const targetX = currentItem ? currentItem.x : contentX
        let targetY = currentItem ? currentItem.y : contentY
        let targetIndex = currentIndex
        const atLeft = currentIndex % columns === (Qt.application.layoutDirection == Qt.RightToLeft ? columns - 1 : 0)
        const isLeading = currentIndex % columns === 0
        const atTop = currentIndex < columns
        const atRight = currentIndex % columns === (Qt.application.layoutDirection == Qt.RightToLeft ? 0 : columns - 1)
        const isTrailing = currentIndex % columns === columns - 1
        let atBottom = currentIndex >= count - columns
        if (count > 1) {
            switch (event.key) {
                case Qt.Key_Left: if (!atLeft && !searchBar.textField.activeFocus) {
                    moveCurrentIndexLeft()
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } break
                case Qt.Key_H: if (!atLeft && !searchBar.textField.activeFocus && event.modifiers & Qt.ControlModifier) {
                    moveCurrentIndexLeft()
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } break
                case Qt.Key_Up: if (!atTop) {
                    moveCurrentIndexUp()
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } break
                case Qt.Key_K: if (!atTop && event.modifiers & Qt.ControlModifier) {
                    moveCurrentIndexUp()
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } break
                case Qt.Key_Right: if (!atRight && !searchBar.textField.activeFocus) {
                    moveCurrentIndexRight()
                    focusCurrentItem(event, Qt.TabFocusReason)
                } break
                case Qt.Key_L: if (!atRight && !searchBar.textField.activeFocus && event.modifiers & Qt.ControlModifier) {
                    moveCurrentIndexRight()
                    focusCurrentItem(event, Qt.TabFocusReason)
                } break
                case Qt.Key_Down: if (!atBottom) {
                    moveCurrentIndexDown()
                    focusCurrentItem(event, Qt.TabFocusReason)
                } break
                case Qt.Key_J: if (!atBottom && event.modifiers & Qt.ControlModifier) {
                    moveCurrentIndexDown()
                    focusCurrentItem(event, Qt.TabFocusReason)
                } break
                case Qt.Key_Home: if (event.modifiers === Qt.ControlModifier && currentIndex !== 0) {
                    currentIndex = 0
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } else if (!isLeading) {
                    targetIndex -= currentIndex % columns
                    currentIndex = Math.max(targetIndex, 0)
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } break
                case Qt.Key_End: if (event.modifiers === Qt.ControlModifier && currentIndex !== count - 1) {
                    currentIndex = count - 1
                    focusCurrentItem(event, Qt.TabFocusReason)
                } else if (!isTrailing) {
                    targetIndex += columns - 1 - (currentIndex % columns)
                    currentIndex = Math.min(targetIndex, count - 1)
                    focusCurrentItem(event, Qt.TabFocusReason)
                } break
                case Qt.Key_PageUp: if (!atTop) {
                    targetY = targetY - height + 1
                    targetIndex = indexAt(targetX, targetY)
                    while (targetIndex === -1) {
                        targetY += 1
                        targetIndex = indexAt(targetX, targetY)
                    }
                    currentIndex = Math.max(targetIndex, 0)
                    focusCurrentItem(event, Qt.BacktabFocusReason)
                } break
                case Qt.Key_PageDown: if (!atBottom) {
                    targetY = targetY + height - 1
                    targetIndex = indexAt(targetX, targetY)
                    while (targetIndex === -1) {
                        targetY -= 1
                        targetIndex = indexAt(targetX, targetY)
                    }
                    currentIndex = Math.min(targetIndex, count - 1)
                    focusCurrentItem(event, Qt.TabFocusReason)
                } break
                case Qt.Key_Return:
                    /* Fall through*/
                case Qt.Key_Enter:
                    grid.currentItem.trigger();
                    grid.currentItem.forceActiveFocus(Qt.ShortcutFocusReason);
                    event.accepted = true;
                    break;
            }
        }
        movedWithKeyboard = event.accepted
        if (movedWithKeyboard) {
            movedWithKeyboardTimer.restart()
        }
    }
}