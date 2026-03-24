import QtQuick
import QtQuick.Controls
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

ListView {
	id: listView
	property real availableWidth:  listView.width - fs.innerPadding
	property bool showSectionSeparator: true
	property bool showScrollbar: true
	property var interceptedPosition: null
	property bool blockingHoverFocus: false

    property bool movedWithKeyboard: false
    property bool movedWithWheel: false
	Accessible.role: Accessible.List
	focus: true
    clip: true
    currentIndex: count > 0 ? 0 : -1
    interactive: height < contentHeight
    boundsBehavior: Flickable.StopAtBounds
    keyNavigationEnabled: false
    keyNavigationWraps: false
    highlightResizeDuration: 0
    highlightMoveDuration: 50
	highlight: Highlight{}
	delegate: AppListViewDelegate {
		triggerModel: listView.model
		width: listView.availableWidth
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
	section {
		property: showSectionSeparator ? "group" : "nosection"
		criteria: ViewSection.FullString
		delegate: PlasmaExtras.ListSectionHeader {
			required property string section
			width: listView.availableWidth
			text: section
		}
    }
	ScrollBar.vertical: Scrollbar {
		id: verticalScrollBar
		parent: listView
		z: 2
		height: listView.height
		anchors.right: listView.right
		visible: showScrollbar
		active: listView.movedWithWheel
	}
	Kirigami.WheelHandler {
		target: listView
		filterMouseEvents: true
	
		horizontalStepSize: 20 * Qt.styleHints.wheelScrollLines
		verticalStepSize: 20 * Qt.styleHints.wheelScrollLines
			onWheel: wheel => {
					if (wheel.angleDelta.y !== 0) {
				listView.flick(wheel.angleDelta.y * 15, 0);
			}
					listView.movedWithWheel = true
			listView.movedWithKeyboard = false
			movedWithWheelTimer.restart()
		}
    }
	Connections {
		target: root
		function onVisibleChanged() {
			if (!root.visible) {
				listView.currentIndex = 0
				listView.positionViewAtBeginning()
			}
		}
    }
    Timer {
		id: movedWithKeyboardTimer
		interval: 200
		onTriggered: listView.movedWithKeyboard = false
    }
	Timer {
		id: movedWithWheelTimer
		interval: 200
		onTriggered: listView.movedWithWheel = false
    }
	function focusCurrentItem(event, focusReason) {
		currentItem.forceActiveFocus(focusReason)
		event.accepted = true
    }
	Keys.onPressed: event => {
		const targetX = currentItem ? currentItem.x : contentX
		let targetY = currentItem ? currentItem.y : contentY
		let targetIndex = currentIndex
		const atFirst = currentIndex === 0
		const atLast = currentIndex === count - 1
		if (count >= 1) {
			switch (event.key) {
			case Qt.Key_Up: if (!atFirst) {
				decrementCurrentIndex()
							if (currentItem.isSeparator) {
					decrementCurrentIndex()
				}
							focusCurrentItem(event, Qt.BacktabFocusReason)
			} break
			case Qt.Key_K: if (!atFirst && event.modifiers & Qt.ControlModifier) {
				decrementCurrentIndex()
				focusCurrentItem(event, Qt.BacktabFocusReason)
			} break
			case Qt.Key_Down: if (!atLast) {
				incrementCurrentIndex()
							if (currentItem.isSeparator) {
					incrementCurrentIndex()
				}
							focusCurrentItem(event, Qt.TabFocusReason)
			} break
			case Qt.Key_J: if (!atLast && event.modifiers & Qt.ControlModifier) {
				incrementCurrentIndex()
				focusCurrentItem(event, Qt.TabFocusReason)
			} break
			case Qt.Key_Home: if (!atFirst) {
				currentIndex = 0
				focusCurrentItem(event, Qt.BacktabFocusReason)
			} break
			case Qt.Key_End: if (!atLast) {
				currentIndex = count - 1
				focusCurrentItem(event, Qt.TabFocusReason)
			} break
			case Qt.Key_PageUp: if (!atFirst) {
				targetY = targetY - height + 1
				targetIndex = indexAt(targetX, targetY)
			
				while (targetIndex === -1) {
					targetY += 1
					targetIndex = indexAt(targetX, targetY)
				}
				currentIndex = Math.max(targetIndex, 0)
				focusCurrentItem(event, Qt.BacktabFocusReason)
			} break
			case Qt.Key_PageDown: if (!atLast) {
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
				listView.currentItem.trigger();
				listView.currentItem.forceActiveFocus(Qt.ShortcutFocusReason);
				event.accepted = true;
				break;
			}
		}
			movedWithKeyboard = event.accepted
			if (movedWithKeyboard) {
			movedWithKeyboardTimer.restart()
		}
    }
	Connections {
		target: blockHoverFocusHandler
		enabled: blockHoverFocusHandler.enabled && !listView.interceptedPosition
		function onPointChanged() {
			listView.interceptedPosition = blockHoverFocusHandler.point.position
		}
	}
	Connections {
		target: blockHoverFocusHandler
		enabled: blockHoverFocusHandler.enabled && listView.interceptedPosition && listView.blockingHoverFocus
		function onPointChanged() {
			if (blockHoverFocusHandler.point.position === listView.interceptedPosition) {
				return;
			}
			listView.blockingHoverFocus = false
		}
	}
	HoverHandler {
		id: blockHoverFocusHandler
		enabled: (!listView.interceptedPosition || listView.blockingHoverFocus)
	}
}
