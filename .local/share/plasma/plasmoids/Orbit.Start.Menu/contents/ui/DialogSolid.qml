import QtQuick 2.15
import org.kde.ksvg as KSvg
import Qt5Compat.GraphicalEffects

Item {

    property int radiusDialog: 17

    KSvg.SvgItem {
        id: svgColor
        imagePath: "dialogs/background"
        elementId: "center"
        visible: false
        width: parent.width
        height: parent.height
    }

    Rectangle {
        id: mask
        color: "white"
        width: parent.width
        height: parent.height
        radius: radiusDialog
        visible: false
    }
    DropShadow {
        anchors.fill: mask
        anchors.centerIn: levelAdjustEffect
        transparentBorder: true
        radius: 12
        color: "black"
        //samples: 25
        opacity: 0.2
        source: mask
    }
    LevelAdjust {
        id: levelAdjustEffect
        width:  svgColor.width +  2
        height: svgColor.height +  1
        source:  svgColor
        minimumOutput: Qt.vector4d(0.0, 0.0, 0.0, 1.0) // Forzar alfa a 1.0
        //maximumOutput: Qt.vector4d(1.0, 1.0, 1.0, 1.0) // Mantener colores
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }
}
