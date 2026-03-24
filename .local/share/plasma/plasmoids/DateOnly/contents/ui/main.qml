import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.0 as Kirigami
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    id: root

    property int orientation: plasmoid.configuration.orientation
    property int orientationAngle: 0
    property double fontSize: 0.1

    Layout.preferredWidth: {
        switch (orientation) {
            case 0: return Kirigami.Units.gridUnit * 10;
            default: return Kirigami.Units.gridUnit * 4;
        }
    }
    Layout.preferredHeight: {
        switch (orientation) {
            case 0: return Kirigami.Units.gridUnit * 2;
            default: return Kirigami.Units.gridUnit * 12;
        }
    }

    

    Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: updateDate()
    }

    function updateDate() {
        dateLabel.text = Qt.formatDate(new Date(), (plasmoid.configuration.dateFormat || "dddd dd MMMM"))

        switch (orientation) {
            case 1:
                orientationAngle = -90
                fontSize = root.width * (plasmoid.configuration.fontSizeRatio / 20)
                break
            case 2:
                orientationAngle = 90
                fontSize = root.width * (plasmoid.configuration.fontSizeRatio / 20)
                break
            case 0:
                orientationAngle = 0
                fontSize = root.width * (plasmoid.configuration.fontSizeRatio / 100)
                break
        }

        labelRotation.angle = orientationAngle
        dateLabel.font.pixelSize = fontSize        
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Text {
            id: dateLabel
            anchors.centerIn: parent
            color: Kirigami.Theme.textColor
            text: Qt.formatDate(new Date(), (plasmoid.configuration.dateFormat || "dddd dd MMMM"))
            font.family: (plasmoid.configuration.fontFamily || "FreeSans")
            font.bold: plasmoid.configuration.fontBold
            font.italic: plasmoid.configuration.fontItalic
            font.pixelSize: fontSize

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.NoWrap

            transform: Rotation {
                id: labelRotation
                origin.x: dateLabel.width / 2
                origin.y: dateLabel.height / 2
                angle: {
                    switch (orientation) {
                        case 1: return -90;
                        case 2: return 90;
                        case 0: return 0;
                    }
                }
            }
        }
    }
}
