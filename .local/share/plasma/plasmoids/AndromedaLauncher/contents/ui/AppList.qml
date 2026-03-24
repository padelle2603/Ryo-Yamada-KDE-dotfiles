/*****************************************************************************
 *   Copyright (C) 2022 by Friedrich Schriewer <friedrich.schriewer@gmx.net> *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 ****************************************************************************/

import Qt5Compat.GraphicalEffects

import QtQuick 2.12
import QtQuick.Controls 2.15

import QtQuick.Layouts 1.0

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

import org.kde.kirigami as Kirigami

import org.kde.draganddrop 2.0


ScrollView {
  id: scrollView

  contentWidth: availableWidth //no horizontal scrolling

  property bool grabFocus: false
  property bool showDescriptions: false

  property QtObject allAppsModel
  property QtObject recentAppsModel

  property var currentStateIndex: Plasmoid.configuration.defaultPage

  property bool hasListener: false
  property bool isRight: true

  property var scrollpositon: 0.0
  property var scrollheight: 0.0

  property var appsCategoriesList: { 

    var categories = [];
    var categoryName;
    var categoryIcon;

    for (var i = 1; i < rootModel.count - 2; i++) {
      categoryName  = rootModel.data(rootModel.index(i, 0), Qt.DisplayRole);
      categoryIcon  = rootModel.data(rootModel.index(i, 0), Qt.DecorationRole);
      categories.push({
        name: categoryName,
        index: i,
        icon: categoryIcon
      });
    }
    scrollView.allAppsModel =  rootModel.modelForRow(1)
    return categories;
  }

  function updateModels() {
      scrollView.allAppsModel = rootModel.modelForRow(1)
  }

  function updateShowedModel(index){

    /* index 1 means that all applications must be shown
      and we need a master repeater that iterates through
      every app category */

    if(index == 1) {

      /* We need a child repeater for each app category
       so we set the master repeater model to the allApps model */

      masterAllAppsRepeater.model = rootModel.modelForRow(index);

      // Set each child repeater's(category repeater) model to the corresponding category model so all apps are shown
      for (var i = 0; i < masterAllAppsRepeater.count; i++ ){
        masterAllAppsRepeater.itemAt(i).model = masterAllAppsRepeater.model.modelForRow(i);
      }
    } else {

      /*  If index is != 0 means that a specific category must be shown,
          so we just need one child repeater */

      masterAllAppsRepeater.model = 1;

      // Sets the unique child repeater's model to the corresponding category
      masterAllAppsRepeater.itemAt(0).model = rootModel.modelForRow(index);
    }
  }

  function incrementCurrentStateIndex() {
    currentStateIndex +=1;
    if (currentStateIndex > appsCategoriesList.length - 1) {
        currentStateIndex = 0;
    }
  }

  function decrementCurrentStateIndex() {
    currentStateIndex -=1;
    if (currentStateIndex < 0) {
      currentStateIndex = appsCategoriesList.length - 1;
    }
  }

  function resetCurrentStateIndex() {
    currentStateIndex = plasmoid.configuration.defaultPage;
  }

  function getCurrentCategory(){
    return appsCategoriesList[currentStateIndex];
  }

  function reset(){
    ScrollBar.vertical.position = 0
    currentStateIndex = plasmoid.configuration.defaultPage
  }
  function get_position(){
    return ScrollBar.vertical.position;
  }
  function get_size(){
    return ScrollBar.vertical.size;
  }
  Connections {
      target: root
      function onVisibleChanged() {
        currentStateIndex = plasmoid.configuration.defaultPage
      }
  }
  onContentHeightChanged: {
    ScrollBar.vertical.position = scrollpositon * scrollheight / scrollView.contentHeight
  }

  Column {

    width: parent.width
    height: parent.height
  
    DropArea {
      width: scrollView.width
      height: scrollView.height
      visible: !main.showAllApps
      onDragMove: event => {

          if(plasmoid.configuration.pinnedModel == 1){ return; }

          var above = flow.childAt(event.x, event.y);

          if (above && above !== kicker.dragSource && dragSource.parent == flow) {
              repeater.model.moveRow(dragSource.itemIndex, above.itemIndex);
          }

      }
      GridView { //Favorites
        id: flow
        anchors.fill: parent

        cellWidth: root.cellSizeWidth
        cellHeight: root.cellSizeHeight
        visible: !main.showAllApps
        model:  plasmoid.configuration.pinnedModel == 0 ? globalFavorites : recentAppsModel
        delegate: FavoriteItem {
          id: favitem
          triggerModel: flow.model
        }
      }
    }

    Grid { //Categories
      id: appCategories
      columns: 1
      width: scrollView.width - 10 * 1
      visible: main.showAllApps
      Repeater {
        id: masterAllAppsRepeater
        delegate: Repeater {
          id: categoryRepeater
          delegate: GenericItem {
            id: genericItemCat
            triggerModel: categoryRepeater.model
          }
        }
      }
    }
  }
  Component.onCompleted: {
    scrollView.recentAppsModel = rootModel.modelForRow(0);
  }
}
