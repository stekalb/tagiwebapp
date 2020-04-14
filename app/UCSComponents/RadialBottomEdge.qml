import QtQuick 2.4
import QtFeedback 5.0
import Ubuntu.Components 1.3
import QtQuick.Window 2.1

Item {
  id: bottomEdge

  property int hintSize: units.gu(6)
  property color hintColor: "#0066cc"
  property string hintIconName: "view-grid-symbolic"
  property alias hintIconSource: hintIcon.source
  property color hintIconColor: "white"
  property bool bottomEdgeEnabled: true


  property real actionButtonSize: units.gu(5)

  property real expandedPosition: height - actionButtonSize - actionButtonSize / 1.5
  //property real collapsedPosition: height - hintSize/2
  property int collapsedPosition: height - actionButtonSize / 1.5 + 1

  property list<RadialAction> actions
  property real actionButtonDistance: actionButtonSize / 4

  anchors.fill: parent

  function writeToLog(mylevel,mytext, mymessage){
    console.log("["+mylevel+"]  "+mytext+" "+mymessage)
    return(true);
  }

  //property string writelog8: writeToLog("DEBUG","Orientation:", Screen.orientation);

  HapticsEffect {
    id: clickEffect
    attackIntensity: 0.0
    attackTime: 50
    intensity: 1.0
    duration: 10
    fadeTime: 50
    fadeIntensity: 0.0
  }

  Rectangle {
    visible: bottomEdgeHint.state !== "collapsed"
    z: -2
    width: parent.width
    height: actionButtonSize
    color: hintColor
    anchors {
      bottom: parent.bottom
    }

    //property string writelog6: writeToLog("DEBUG","anchor bottom:", Screen.height - hintSize);
    //property string writelog5: writeToLog("DEBUG","visible column:", visible);

    Repeater {
      id: actionList
      model: actions

      Rectangle { 
        width: actionButtonSize
        height: width
        //radius: width
        color: hintColor
        
        transform: Translate {
          x: (index * actionButtonSize) + index * 5
        }

        Icon {
          id: icon
          anchors.centerIn: parent
          width: parent.width/2
          height: width
          color: hintIconColor
          //opacity: modelData.enabled ? 1.0 : 0.2
          Component.onCompleted: modelData.iconSource ? source = Qt.resolvedUrl(modelData.iconSource) : name = modelData.iconName
        }
        
        Label {
          visible: text && bottomEdgeHint.state == "expanded"
          text: modelData.text
          anchors {
            top: !modelData.top ? icon.bottom : undefined
            topMargin: !modelData.top ? units.gu(3) : undefined
            bottom: modelData.top ? icon.top : undefined
            bottomMargin: modelData.top ? units.gu(3) : undefined
            horizontalCenter: icon.horizontalCenter
          }
          color: hintIconColor
          font.bold: false
          fontSize: "medium"
        }     
        MouseArea {
          anchors.fill: parent
          enabled: modelData.enabled
          onClicked: {
            clickEffect.start()
            bottomEdgeHint.state = "collapsed"
            modelData.triggered(null)
          }
        }   
        //property string writelog1: writeToLog("DEBUG","Count:", index);
        //property string writelog6: writeToLog("DEBUG","x"+index+":" , index * actionButtonSize/4);
      }
    }
  }

  Rectangle {
    id: bottomEdgeHint
//    z:-1
    height: actionButtonSize / 1.5
    width: height + hintSize
    color: hintColor
    /*anchors {
      bottom: parent.bottom
      right: parent.right
      //rightMargin: hintSize / 4
    }*/

    anchors.horizontalCenter: parent.horizontalCenter
        y: collapsedPosition
        z: parent.z + 1
    //width: hintSize
    //height: width
    //radius: width
    visible: bottomEdgeEnabled

    property string writelog4: writeToLog("DEBUG","bottomEdgeHint visibility:", visible);

    Icon {
      id: hintIcon
      width: hintSize/4
      height: width
      name: hintIconName
      color: hintIconColor
      anchors {
        centerIn: parent
      }
    }

    //property real actionListDistance: - actionButtonDistance
    

    MouseArea {
        id: mouseArea

        property real previousY: -1
        property string dragDirection: "None"

        z: 1
        anchors.fill: parent
        visible: bottomEdgeEnabled

        preventStealing: true
        drag {
          axis: Drag.YAxis
          target: bottomEdgeHint
          minimumY: expandedPosition
          maximumY: collapsedPosition
        }

        onClicked: {
          if (bottomEdgeHint.state == "collapsed"){
            bottomEdgeHint.state = "expanded"
          }
          else{
            bottomEdgeHint.state = "collapsed"
          }
        }
        onWheel: {
          if (bottomEdgeHint.state == "expanded"){
            bottomEdgeHint.state = "collapsed"
          }
        }

        property string writelog0: writeToLog("DEBUG","Triggered state change to: ", bottomEdgeHint.state);
    }

    state: "collapsed"
    states: [
      State {
        name: "collapsed"
        PropertyChanges {
          target: bottomEdgeHint
          y: collapsedPosition
        }
      },
      State {
        name: "expanded"
        PropertyChanges {
          target: bottomEdgeHint
          y: expandedPosition
        }
      },

      State {
        name: "floating"
        when: mouseArea.drag.active
      }
    ]

    transitions: [
      Transition {
        to: "expanded"
        SpringAnimation {
          target: bottomEdgeHint
          property: "x"
          spring: 5
          damping: .2
          mass: 10
         // epsilon: .05
        }
      },

      Transition {
        to: "collapsed"
        SpringAnimation {
          target: bottomEdgeHint
          property: "x"
          spring: 5
          damping: .2
          mass: 10
          epsilon: .05
        }
      }
    ]
  }
}
