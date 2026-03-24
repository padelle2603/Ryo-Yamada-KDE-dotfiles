import QtQuick
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.kirigami as Kirigami

Item {

    property bool searchTabActive: false

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
     CardHeaded {
         id: cardHeaded
         width: parent.width
         height: parent.height
         rotation: 180
    }
    Rectangle {
        width: parent.width
        height: parent.height
        color: Kirigami.Theme.highlightColor
        rotation: 180  // Rotar 45 grados
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: cardHeaded
        }

    }

    ListModel {
        id: userDirs

        ListElement {
            text: "Search"
            icon: "search-symbolic"
            command: "xdg-open $HOME"
        }
        ListElement {
            text: "Home"
            icon: "user-home-symbolic"
            command: "xdg-open $HOME"
        }
        ListElement {
            text: "Documents"
            icon: "folder-documents-symbolic"
            command: "xdg-open $(xdg-user-dir DOCUMENTS)"
        }
        ListElement {
            text: "Music"
            icon: "folder-music-symbolic"
            command: "xdg-open $(xdg-user-dir MUSIC)"
        }
        ListElement {
            text: "Pictures"
            icon: "folder-pictures-symbolic"
            command: "xdg-open $(xdg-user-dir PICTURES)"
        }
        ListElement {
            text: "Videos"
            icon: "folder-videos-symbolic"
            command: "xdg-open $(xdg-user-dir VIDEOS)"
        }
    }

    Row {
        width: (userDirs.count * 34)
        height: 24
        anchors.verticalCenter: parent.verticalCenter
        visible: !searchTabActive
        anchors.horizontalCenter: parent.horizontalCenter
        //spacing: 5
        Repeater {
            id: icons
            model: userDirs
            delegate: Item {
                id: iconItem
                width: 34
                height: parent.height
                Kirigami.Icon {
                    width: 24
                    height: 24
                    isMask: true
                    source: model.icon
                    color:  Kirigami.Theme.highlightTextColor
                }
                MouseArea {
                    anchors.fill: iconItem
                    anchors.centerIn: iconItem
                    onClicked: {
                        console.log(model.command)
                        if (model.text === "Search") {
                            searchTabActive = true
                        } else {
                            executable.exec(model.command);
                        }

                    }
                }
            }
        }
    }
}
