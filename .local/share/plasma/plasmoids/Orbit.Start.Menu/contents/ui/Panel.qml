import QtQuick 2.15
import org.kde.ksvg as KSvg
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami

Item {
    property string tabActive: "All"
    property int maxWidth: tab.implicitWidth + tabModel.count*10
    property int radiusPanel: base.radiusDialog
    //property bool newValues: false
    property bool activeSearch: false

    signal newValues

    DialogSolid {
        id: base
        width: parent.width
        height: parent.height

        ListModel {
            id: tabModel

            ListElement {
                text: "All"
            }
            ListElement {
                text: "Favorites"
            }
        }
        Row {
            id: tab
            width: we.implicitWidth
            height: parent.height
            spacing: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            Repeater {
                id: we
                model: tabModel
                delegate:  MouseArea {
                    width: text.implicitWidth + 10
                    height: tab.height
                    onClicked: {
                        tabActive = model.text
                        newValues()
                        activeSearch = false
                    }
                    Row {
                        id: ro
                        width: text.implicitWidth + 10
                        height: tab.height
                        spacing: 5
                        Rectangle {
                            width: 5
                            height: 5
                            radius: height
                            color:  Kirigami.Theme.highlightColor
                            visible: !activeSearch && tabActive === model.text
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            id: text
                            height: parent.height
                            text: i18n(model.text)
                            verticalAlignment: Text.AlignVCenter
                            color: Kirigami.Theme.textColor
                            font.bold: !activeSearch && tabActive === model.text
                            opacity: tabActive === model.text && !activeSearch ? 1 : 0.7
                        }
                    }
                }
            }
        }

    }


}
