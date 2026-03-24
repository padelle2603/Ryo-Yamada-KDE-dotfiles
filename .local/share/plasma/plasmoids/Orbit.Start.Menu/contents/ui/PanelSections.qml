import QtQuick

Item {
    property bool solid: false
    PanelFloting {
        id: panel
        solid: solid
        width: parent.width
        height: parent.height
    }
}
