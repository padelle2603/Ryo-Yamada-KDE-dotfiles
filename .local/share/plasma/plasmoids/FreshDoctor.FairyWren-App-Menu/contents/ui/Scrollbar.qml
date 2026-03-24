import QtQuick
import QtQuick.Controls.Basic

ScrollBar {
    id: control
    z: 2
    implicitWidth: 12
    padding: 0
    contentItem: Rectangle {
        implicitWidth: 10
        implicitHeight: 100
        radius: width / 2
        color: control.pressed ?  main.textColor : main.dimmedTextColor
        opacity: control.policy === ScrollBar.AlwaysOn || (control.active && control.size < 1.0) ? 0.75 : 0
        Behavior on opacity {
            NumberAnimation {}
        }
    }


    background: Rectangle{
        color: control.active ? main.contrastBgColor : "transparent"
        opacity: control.policy === ScrollBar.AlwaysOn || (control.active && control.size < 1.0) ? 1 : 0
        Behavior on opacity {
            NumberAnimation {}
        }
        radius: width / 2
    }
}