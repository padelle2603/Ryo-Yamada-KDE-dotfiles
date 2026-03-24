/*
 *  SPDX-FileCopyrightText: zayronxio
 *  SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.private.kicker 0.1 as Kicker
//import org.kde.plasma.private.shell 2.0
import org.kde.kwindowsystem 1.0
import QtQuick.Controls
import org.kde.kirigami as Kirigami

Item{
    id: main
    property int menuPos: Plasmoid.configuration.displayPosition
    //property int showApps: tab.tabActive === "All" ? 0 : 1

    onVisibleChanged: {
        root.visible = !root.visible
    }

    PlasmaExtras.Menu {
        id: contextMenu

        PlasmaExtras.MenuItem {
            action: Plasmoid.internalAction("configure")
        }
    }

    Plasmoid.status: root.visible ? PlasmaCore.Types.RequiresAttentionStatus : PlasmaCore.Types.PassiveStatus

    PlasmaCore.Dialog {
        id: root

        objectName: "popupWindow"
        flags: Qt.WindowStaysOnTopHint
        //flags: Qt.Dialog | Qt.FramelessWindowHint
        location: PlasmaCore.Types.Floating
        hideOnWindowDeactivate: true

        property int iconSize: Kirigami.Units.iconSizes.large
        property int cellSizeHeight: iconSize
                                     + Kirigami.Units.gridUnit * 2
                                     + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                                                     highlightItemSvg.margins.left + highlightItemSvg.margins.right))
        property int cellSizeWidth: cellSizeHeight

        property bool searching: (searchField.text != "")

        property bool showFavorites

        onVisibleChanged: {
            if (visible) {
                root.showFavorites = Plasmoid.configuration.showFavoritesFirst
                cardAcces.searchTabActive = false
                var pos = popupPosition(width, height);
                x = pos.x;
                y = pos.y;
                reset();
                animation1.start()
            }else{
                rootItem.opacity = 0
            }
        }

        onHeightChanged: {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
        }

        onWidthChanged: {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
        }

        function toggle(){
            main.visible =  !main.visible
        }


        function reset() {
            searchField.text = "";

            if(showFavorites)
                globalFavoritesGrid.tryActivate(0,0)
            else
                mainColumn.visibleGrid.tryActivate(0,0)


        }

        function popupPosition(width, height) {
            var screenAvail = kicker.availableScreenRect;
            var screen = kicker.screenGeometry;
            var panelH = kicker.height
            var panelW = kicker.width
            var horizMidPoint = screen.x + (screen.width / 2);
            var vertMidPoint = screen.y + (screen.height / 2);
            var appletTopLeft = parent.mapToGlobal(0, 0);

            function calculatePosition(x, y) {
                return Qt.point(x, y);
            }

            if (menuPos === 0) {
                switch (plasmoid.location) {
                    case PlasmaCore.Types.BottomEdge:
                        var x = appletTopLeft.x < screen.width - width ? appletTopLeft.x : screen.width - width - 8;
                        var y = appletTopLeft.y - height - Kirigami.Units.gridUnit
                        return calculatePosition(x, y);

                    case PlasmaCore.Types.TopEdge:
                        x = appletTopLeft.x < screen.width - width ? appletTopLeft.x + panelW - Kirigami.Units.gridUnit / 3 : screen.width - width;
                        y = appletTopLeft.y + kicker.height + Kirigami.Units.gridUnit
                        return calculatePosition(x, y);

                    case PlasmaCore.Types.LeftEdge:
                        x = appletTopLeft.x + panelW + Kirigami.Units.gridUnit / 2;
                        y = appletTopLeft.y < screen.height - height ? appletTopLeft.y : appletTopLeft.y - height + iconUser.height / 2;
                        return calculatePosition(x, y);

                    case PlasmaCore.Types.RightEdge:
                        x = appletTopLeft.x - width - Kirigami.Units.gridUnit / 2;
                        y = appletTopLeft.y < screen.height - height ? appletTopLeft.y : screen.height - height - Kirigami.Units.gridUnit / 5;
                        return calculatePosition(x, y);

                    default:
                        return;
                }
            } else if (menuPos === 2) {
                x = horizMidPoint - width / 2;
                y = screen.height - height - panelH - Kirigami.Units.gridUnit / 2;
                return calculatePosition(x, y);
            } else if (menuPos === 1) {
                x = horizMidPoint - width / 2;
                y = vertMidPoint - height / 2;
                return calculatePosition(x, y);
            }
        }

        FocusScope {
            id: rootItem
            Layout.minimumWidth:  Kirigami.Units.gridUnit*20
            Layout.maximumWidth:  minimumWidth
            Layout.minimumHeight: Kirigami.Units.gridUnit*32
            Layout.maximumHeight: minimumHeight
            focus: true

            property string tabM: tab.tabActive

            Headed {
                id: headed
                radiusDailog: tab.radiusPanel
                width: parent.width + backgroundSvg.margins.left * 2
                height: parent.height/6
                y:  - backgroundSvg.margins.top
                x: - backgroundSvg.margins.left
                opacity: 0.8
            }

            CardAcces {
                id: cardAcces
                width: parent.width + backgroundSvg.margins.left*2
                height: Kirigami.Units.gridUnit * 2.5
                anchors.top: parent.bottom
                anchors.topMargin: - height + backgroundSvg.margins.top
                x: - backgroundSvg.margins.left
            }

            Panel {
                id: tab
                width: maxWidth
                height: 34
                visible: true
                activeSearch: cardAcces.searchTabActive
                anchors.bottom: headed.bottom
                anchors.bottomMargin: -height/2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            onTabMChanged: {
              cardAcces.searchTabActive = false
                //reset();
                searchField.text = ""
                searchField.clear()
           }

            OpacityAnimator { id: animation1; target: rootItem; from: 0; to: 1; easing.type: Easing.InOutQuad;  }


            PlasmaExtras.Highlight  {
                id: delegateHighlight
                visible: false
                z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
            }

            Kirigami.Heading {
                id: dummyHeading
                visible: false
                width: 0
                level: 5
            }

            TextMetrics {
                id: headingMetrics
                font: dummyHeading.font
            }

            RowLayout {
                id: rowSearchField
                width: parent.width*.5
                visible: cardAcces.searchTabActive
                anchors{
                    centerIn: cardAcces
                }


                PC3.TextField {
                    id: searchField
                    width: 50
                    placeholderText: i18n("Type here to search ...")
                    topPadding: 10
                    bottomPadding: 10
                    leftPadding: ((parent.width - width)/2) + Kirigami.Units.iconSizes.small*2
                    text: ""
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize
                    onTextChanged: {
                        runnerModel.query = text;
                    }

                    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Escape) {
                            cardAcces.searchTabActive = false
                            event.accepted = true;
                            if(root.searching){
                                searchField.clear()
                            } else {
                                root.toggle()
                            }
                        }

                        if (event.key === Qt.Key_Down || event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab) {
                            event.accepted = true;
                            if(root.showFavorites)
                                globalFavoritesGrid.tryActivate(0,0)
                                else
                                    mainColumn.visibleGrid.tryActivate(0,0)
                        }
                    }

                    function backspace() {
                        if (!root.visible) {
                            return;
                        }
                        focus = true;
                        text = text.slice(0, -1);
                    }

                    function appendText(newText) {
                        if (!root.visible) {
                            return;
                        }
                        focus = true;
                        text = text + newText;
                    }
                    Kirigami.Icon {
                        source: 'search'
                        anchors {
                            left: searchField.left
                            verticalCenter: searchField.verticalCenter
                            leftMargin: Kirigami.Units.smallSpacing * 2

                        }
                        height: Kirigami.Units.iconSizes.small
                        width: height
                    }

                }

                Item {
                    Layout.fillWidth: true
                }


            }




            ItemGridView {
                id: globalFavoritesGrid
                visible: tab.tabActive === "Favorites"
                x: 5
                anchors {
                    top: tab.bottom
                    topMargin: Kirigami.Units.gridUnit * .5
                }

                dragEnabled: true
                dropEnabled: true
                width: parent.width
                height: cellHeight*4
                focus: true
                cellWidth:   115
                cellHeight:  96
                iconSize:    40
                onKeyNavUp: searchField.focus = true
                Keys.onPressed:(event)=> {
                    if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier){
                        searchField.focus = true;
                        return
                    }
                    if (event.key === Qt.Key_Tab) {
                        event.accepted = true;
                        searchField.focus = true
                    }
                }
            }


            Item{
                id: mainGrids
                visible: !globalFavoritesGrid.visible

                anchors {
                    top: tab.bottom
                    topMargin: Kirigami.Units.gridUnit * .5
                    //left: parent.left
                    //right: parent.right

                }

                width: parent.width
                height: allAppsGrid.height

                Item {
                    id: mainColumn
                    //width: root.cellSize *  Plasmoid.configuration.numberColumns + Kirigami.Units.gridUnit
                    width: rootItem.width
                    height: allAppsGrid.height

                    property Item visibleGrid: allAppsGrid

                    function tryActivate(row, col) {
                        if (visibleGrid) {
                            visibleGrid.tryActivate(row, col);
                        }
                    }

                    ItemGridView {
                        id: allAppsGrid
                        x: 5
                        //width: root.cellSize *  Plasmoid.configuration.numberColumns + Kirigami.Units.gridUnit
                        width: parent.width
                        height: cellHeight*4
                        cellWidth:   115
                        cellHeight:  96
                        iconSize:    40
                        enabled: (opacity == 1) ? 1 : 0
                        z:  enabled ? 5 : -1
                        dropEnabled: false
                        dragEnabled: false
                        opacity: root.searching ? 0 : 1
                        onOpacityChanged: {
                            if (opacity == 1) {
                                //allAppsGrid.scrollBar.flickableItem.contentY = 0;
                                mainColumn.visibleGrid = allAppsGrid;
                            }
                        }
                        onKeyNavUp: searchField.focus = true
                    }

                    ItemMultiGridView {
                        id: runnerGrid
                        width: parent.width
                        height: cellHeight*4
                        cellWidth:   115
                        cellHeight:  96
                        //iconSize:    40
                        enabled: true
                        visible: (opacity == 1.0) ? 1 : 0
                        z:  enabled ? 5 : -1
                        model: runnerModel
                        grabFocus: true
                        opacity: root.searching ? 1.0 : 0.0
                        onOpacityChanged: {
                            if (opacity == 1.0) {
                                mainColumn.visibleGrid = runnerGrid;
                            }
                        }
                        onKeyNavUp: searchField.focus = true
                    }

                    Keys.onPressed: (event)=> {
                        if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier){
                            searchField.focus = true;
                            return
                        }
                        if (event.key === Qt.Key_Tab) {
                            event.accepted = true;
                            searchField.focus = true
                        } else if (event.key === Qt.Key_Backspace) {
                            event.accepted = true;
                            if(root.searching)
                                searchField.backspace();
                            else
                                searchField.focus = true
                        } else if (event.key === Qt.Key_Escape) {
                            event.accepted = true;
                            if(root.searching){
                                searchField.clear()
                            } else {
                                root.toggle()
                            }
                        } else if (event.text !== "") {
                            event.accepted = true;
                            searchField.appendText(event.text);
                            tab.tabActive = "ALL"
                            cardAcces.searchTabActive = true
                        }
                    }
                }
            }




            Keys.onPressed: (event)=> {
                if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier){
                    searchField.focus = true;
                    return
                }
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    if (root.searching) {
                        reset();
                    } else {
                        root.visible = false;
                    }
                    return;
                }

                if (searchField.focus) {
                    return;
                }

                if (event.key === Qt.Key_Backspace) {
                    event.accepted = true;
                    searchField.backspace();
                }  else if (event.text !== "") {
                    event.accepted = true;
                    searchField.appendText(event.text);
                }
            }

        }


        function setModels(){
            globalFavoritesGrid.model = globalFavorites
            allAppsGrid.model = rootModel.modelForRow(0);
        }

        Component.onCompleted: {
            rootModel.refreshed.connect(setModels)
            reset();
            rootModel.refresh();
        }
    }



}
