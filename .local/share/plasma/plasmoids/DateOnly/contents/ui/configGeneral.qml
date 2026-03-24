import QtQuick
import QtQuick.Controls 
import QtQuick.Layouts
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {

    property alias cfg_fontBold: boldCheck.checked
    property alias cfg_fontItalic: italicCheck.checked
    property alias cfg_fontSizeRatio: fontSizeSpin.value
    property alias cfg_fontFamily: fontFamilyField.currentText
    property alias cfg_orientation: orientationCombo.currentIndex
    property alias cfg_dateFormat: dateFormatField.text

    Kirigami.FormLayout {

        ComboBox {
            id: fontFamilyField
            Kirigami.FormData.label: i18n("Font")
            editable: true

            model: ListModel {
                id: fontModel
                ListElement { text: "Loading fonts list..." }
            }

            Timer {
                id: fontLoadTimer
                interval: 100
                running: false
                repeat: false
                onTriggered: {
                    Qt.callLater(function () {
                        const fonts = Qt.fontFamilies()
                        const currentFont = plasmoid.configuration.fontFamily || ""

                        fontModel.clear()
                        let indexToSelect = 0

                        for (let i = 0; i < fonts.length; ++i) {
                            fontModel.append({ text: fonts[i] })
                            if (fonts[i] === currentFont) {
                                indexToSelect = i
                            }
                        }

                        fontFamilyField.currentIndex = indexToSelect
                    })
                }
            }

            Component.onCompleted: fontLoadTimer.start()
        }

        SpinBox {
            id: fontSizeSpin
            Kirigami.FormData.label: i18n("Size")
            from: 0
            value: 10
            to: 30
        }

        CheckBox {
            id: boldCheck
            text: i18n("Bold")
            Kirigami.FormData.label: i18n("Style")
        }

        CheckBox {
            id: italicCheck
            text: i18n("Italic")
        }

        ComboBox {
            id: orientationCombo
            Kirigami.FormData.label: i18n("Orientation")
            
            model: [
                i18n("Horizontal"),
                i18n("Vertical bottom to top"),
                i18n("Vertical top to bottom")
            ]

            currentIndex: {
                switch (plasmoid.configuration.orientation) {
                    case 1: return 1;
                    case 2: return 2;
                    default: return 0;
                }
            }

            onCurrentIndexChanged: {
                switch (currentIndex) {
                    case 1: plasmoid.configuration.orientation = 1; break;
                    case 2: plasmoid.configuration.orientation = 2; break;
                    default: plasmoid.configuration.orientation = 0; break;
                }
            }
        }

        TextField {
            id: dateFormatField
            Kirigami.FormData.label: i18n("Date Format")
            text: "dddd dd MMMM"
        }

        Text {
            text: "
d       day as a number (1-31)
dd      day as a number (01-31)
ddd     day as an abbreviation (Sun-Sat)
dddd    day as a full name (Sunday-Saturday)
M       month as a number (1-12)
MM      month as a number (01-12)
MMM     month as an abbreviation (Jan-Dec)
MMMM    month as a full name (January-December)
yy      year as a two-digit number (00-99)
yyyy    year as a four-digit number (0000-9999)
/       date separator character
'xx'    displayed as is"
            font.family: "Monospace"
            font.pointSize: 9
            color: Kirigami.Theme.disabledTextColor
        }
    }
}
