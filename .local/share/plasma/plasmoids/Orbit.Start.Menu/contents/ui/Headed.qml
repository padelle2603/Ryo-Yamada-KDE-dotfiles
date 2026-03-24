import QtQuick 2.4
import org.kde.coreaddons 1.0 as KCoreAddons
//import QtQuick.Effects
import org.kde.plasma.private.sessions as Sessions
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects
import org.kde.kcmutils // KCMLauncher

Item {
    id:  rootHeaded

    property int radiusDailog: 0

    KCoreAddons.KUser {
        id: kuser
    }

    Sessions.SessionManagement {
        id: sm
    }

    CardHeaded {
        width: parent.width
        height: parent.height

        Item {
            id: containerAvatar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Kirigami.Units.gridUnit/2

            Rectangle {
                id: mask
                width: avatar.width
                height: avatar.height
                radius: height/2
                color: "black"
                anchors.centerIn: avatar
                visible: false
            }

            DropShadow {
                anchors.fill: mask
                anchors.centerIn: avatar
                radius: 8.0
                color: "#80000000"
                source: mask
            }
            Image {
                id: avatar
                source: kuser.faceIconUrl
                height: 64
                width: height
                anchors.horizontalCenter: parent.horizontalCenter
                visible: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        KCMLauncher.openSystemSettings("kcm_users")
                    }
                }
            }
        }

        Item {
            id: bottons
            width: containerButtons.width
            anchors.top: containerAvatar.top
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 5

            ListModel {
                id: bottonsModel

                ListElement {
                    text: "System Settings"
                    icon: "configure"
                    command: "systemsettings"
                }
                ListElement {
                    text: "shutdown"
                    icon: "system-shutdown-symbolic.svg"
                    //command: sm.requestLogoutPrompt()
                }
                //ListElement {
                //    text: "categories"
                //    icon: "open-menu-symbolic"
                //    command: "xdg-open $(xdg-user-dir PICTURES)"
               // }


            }
            Row {
                id: containerButtons
                width: bottonsModel.count*(24 + spacing )
                height: 24
                spacing: 5

                Repeater {
                    model: bottonsModel
                    delegate: Kirigami.Icon {
                        height: 24
                        width: 24
                        source: model.icon
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                 if (model.text === "shutdown") {
                                     sm.requestLogoutPrompt()
                                } else {
                                    if (model.text === "System Settings") {
                                        KCMLauncher.openSystemSettings("")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    }

}
