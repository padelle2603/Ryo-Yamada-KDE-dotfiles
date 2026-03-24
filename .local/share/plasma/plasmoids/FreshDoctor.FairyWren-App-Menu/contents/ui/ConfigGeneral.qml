import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.draganddrop 2.0 as DragDrop
import org.kde.kirigami 2.3 as Kirigami
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    id: configGeneral
    property bool isDash: (Plasmoid.pluginName === "org.kde.plasma.kickerdash")
    property string cfg_icon: Plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: Plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: Plasmoid.configuration.customButtonImage
    property alias cfg_floating: floating.checked
    property alias cfg_launcherPosition: launcherPosition.currentIndex
    property alias cfg_offsetX: screenOffset.value
    property alias cfg_offsetY: panelOffset.value
    property alias cfg_useSystemFontSettings: useSystemFontSettings.checked
    property alias cfg_appsIconSize: appsIconSize.currentIndex
    property alias cfg_numberColumns: numberColumns.value
    property alias cfg_compactListItems: compactListItems.checked
    property alias cfg_showListItemDescription: showListItemDescription.checked
    property alias cfg_showFavouritesFirst: showFavouritesFirst.checked
  Kirigami.FormLayout {
    anchors.left: parent.left
    anchors.right: parent.right
    Button {
      id: iconButton
      Kirigami.FormData.label: i18n("Icon:")
      implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
      implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2
      checkable: true
      checked: dropArea.containsAcceptableDrag
      onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()
      DragDrop.DropArea {
          id: dropArea
          property bool containsAcceptableDrag: false
          anchors.fill: parent
          onDragEnter: {
              var urlString = event.mimeData.url.toString();
              var extensions = [".png", ".xpm", ".svg", ".svgz"];
              containsAcceptableDrag = urlString.indexOf("file:///") === 0 && extensions.some(function (extension) {
                  return urlString.indexOf(extension) === urlString.length - extension.length; // "endsWith"
              });
              if (!containsAcceptableDrag) {
                  event.ignore();
              }
          }
          onDragLeave: containsAcceptableDrag = false
          onDrop: {
              if (containsAcceptableDrag) {
                  // Strip file:// prefix, we already verified in onDragEnter that we have only local URLs.
                  iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
              }
              containsAcceptableDrag = false;
          }
      }
      KIconThemes.IconDialog {
          id: iconDialog
              function setCustomButtonImage(image) {
              configGeneral.cfg_customButtonImage = image || configGeneral.cfg_icon || "start-here-kde-symbolic"
              configGeneral.cfg_useCustomButtonImage = true;
          }
              onIconNameChanged: setCustomButtonImage(iconName);
      }
      KSvg.FrameSvgItem {
          id: previewFrame
          anchors.centerIn: parent
          imagePath: Plasmoid.location === PlasmaCore.Types.Vertical || Plasmoid.location === PlasmaCore.Types.Horizontal
                  ? "widgets/panel-background" : "widgets/background"
          width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
          height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom
              Kirigami.Icon {
              anchors.centerIn: parent
              width: Kirigami.Units.iconSizes.large
              height: width
              source: configGeneral.cfg_useCustomButtonImage ? configGeneral.cfg_customButtonImage : configGeneral.cfg_icon
          }
      }
      Menu {
          id: iconMenu
              // Appear below the button
          y: +parent.height
              onClosed: iconButton.checked = false;
              MenuItem {
              text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
              icon.name: "document-open-folder"
              onClicked: iconDialog.open()
          }
          MenuItem {
              text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
              icon.name: "edit-clear"
              onClicked: {
                  configGeneral.cfg_icon = "start-here-kde-symbolic"
                  configGeneral.cfg_useCustomButtonImage = false
              }
          }
      }
    }

    ComboBox {
        id: launcherPosition
        Kirigami.FormData.label: i18n("Launcher Positioning:")
        model: [
        i18n("Default"),
        i18n("Horizontal Center"),
        i18n("Screen Center"),
        ]
        onCurrentIndexChanged: {
          if (currentIndex == 2) {
            floating.enabled = false
            floating.checked = true
          } else {
            floating.enabled = true
          }
        }
    }
    CheckBox {
      id: floating
      text: i18n("Floating")
      onCheckedChanged: {
        screenOffset.visible = checked
        panelOffset.visible = checked
      }
    }
    Slider {
      id: screenOffset
      visible: Plasmoid.configuration.floating
      Kirigami.FormData.label: i18n("Offset Screen Edge (0 is Default):")
      from: 0
      value: 0
      to: 100
      stepSize: 10
      PlasmaComponents.ToolTip {
          text: screenOffset.value
      }
    }
    Slider {
      id: panelOffset
      visible: Plasmoid.configuration.floating
      Kirigami.FormData.label: i18n("Offset Panel (0 is Default):")
      from: 0
      value: 0
      to: 100
      stepSize: 10
      PlasmaComponents.ToolTip {
          text: panelOffset.value
      }
    }
    
    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Grids and lists")
    }

    ComboBox {
        id: appsIconSize
        Kirigami.FormData.label: i18n("Grid icon size:")
        model: [i18n("48"),i18n("64"),i18n("80"), i18n("96"),i18n("112"), i18n("128")]
    }
    SpinBox{
      id: numberColumns
      from: 4
      to: 7
      Kirigami.FormData.label: i18n("Number of columns in grid")
    }
    CheckBox {
      id: showFavouritesFirst
      text: i18n("Show favourites by default")
    }
    CheckBox {
      id: compactListItems
      Kirigami.FormData.label: i18n("Lists:")
      text: i18n("Compact list items")
    }
    CheckBox {
      id: showListItemDescription
      text: i18n("Show list item description")
    }
    Item {
        Kirigami.FormData.isSection: true
    }
    CheckBox {
      id: useSystemFontSettings
      Kirigami.FormData.label: i18n("Use system font settings")
      text: i18n("Enabled")
      checked: Plasmoid.configuration.useSystemFontSettings
    }
  }
}
