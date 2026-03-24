import QtQuick
import org.kde.ksvg 1.0 as KSvg

Item {

    Grid {
        id: maskSvg2
        width: parent.width
        height: parent.height
        //visible: false
        columns: 3
        KSvg.SvgItem {
            id: topleft2
            imagePath: "dialogs/background"
            elementId: "topleft"
        }
        KSvg.SvgItem {
            id: top2
            imagePath: "dialogs/background"
            elementId: "top"
            width: parent.width - topright2.implicitWidth *2
        }
        KSvg.SvgItem {
            id: topright2
            imagePath: "dialogs/background"
            elementId: "topright"
        }
        KSvg.SvgItem {
            id: left2
            imagePath: "dialogs/background"
            elementId: "left"
            height: parent.height - topright2.implicitHeight
        }
        KSvg.SvgItem {
            imagePath: "dialogs/background"
            elementId: "center"
            height: parent.height - topright2.implicitHeight
            width: top2.width
        }
        KSvg.SvgItem {
            id: right2
            imagePath: "dialogs/background"
            elementId: "right"
            height: parent.height - topright2.implicitHeight
        }
    }


    Rectangle {
        width: parent.width
        anchors.top: maskSvg2.bottom
        anchors.topMargin: 1
        height: 1
        color: "white"
        opacity: 0.2
    }
}
