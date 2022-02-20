import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import Morph.Web 0.1
import QtWebEngine 1.10
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1
import QtMultimedia 5.8
import Qt.labs.settings 1.0
import "UCSComponents"
import "config.js" as Conf

MainView {
  id:window
  //
  // ScreenSaver {
  //   id: screenSaver
  //   screenSaverEnabled: !(Qt.application.active)
  // }

  objectName: "mainView"
  //theme.name: "Ubuntu.Components.Themes.SuruDark"
  backgroundColor: Conf.AppBackgroundColor
  applicationName: "tagiwebapp.ste-kal"

  property string myTabletUrl: Conf.TabletUrl
  property string myMobileUrl: Conf.MobileUrl
  property string myTabletUA: Conf.TabletUA
  property string myMobileUA: Conf.MobileUA
  property string title: Conf.AppTitle

  property string myUrl: (Screen.devicePixelRatio == 1.625) ? myTabletUrl : myMobileUrl
  //property string myUrl: "http://www.tagesanzeiger.ch"
  property string myUA: (Screen.devicePixelRatio == 1.625) ? myTabletUA : myMobileUA
  //"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/67.0.3396.99 Chrome/67.0.3396.99 Safari/537.36"

    

  WebEngineView {
    id: webview
    anchors {
      fill: parent
    }
    //settings.localStorageEnabled: true
    //settings.allowFileAccessFromFileUrls: true
    //settings.allowUniversalAccessFromFileUrls: true
    //settings.appCacheEnabled: true
    settings.javascriptCanAccessClipboard: true
    settings.fullScreenSupportEnabled: true
    settings.showScrollBars: false
    property var currentWebview: webview
    settings.pluginsEnabled: true

    onFullScreenRequested: function(request) {
      mainview.fullScreenRequested(request.toggleOn);
      nav.visible = !nav.visible
      request.accept();
    }
    property string test: writeToLog("DEBUG","my URL:", myUrl);
    property string test2: writeToLog("DEBUG","PixelRatio:", Screen.devicePixelRatio);
    function writeToLog(mylevel,mytext, mymessage){
      console.log("["+mylevel+"]  "+mytext+" "+mymessage)
      return(true);
    }

    profile:  WebEngineProfile {
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath
      dataPath: dataLocation
      httpUserAgent: myUA
      httpCacheType: WebEngineProfile.NoCache
      offTheRecord: false
    }

    anchors {
      fill:parent
      centerIn: parent.verticalCenter
    }

    url: myUrl
    /*userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentCreation
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]*/
    
  }

  RadialBottomEdge {
    id: nav
    visible: true
    actions: [
      RadialAction {
        id: home
        iconName: "home"
        onTriggered: {
          webview.url = myUrl
        }
        text: qsTr("Home")
      },
      RadialAction {
        id: reload
        iconName: "reload"
        onTriggered: {
          webview.reload()
        }
        text: qsTr("Reload")
      },
      RadialAction {
        id: international
        iconSource: Qt.resolvedUrl("icons/0202-sphere.svg")
        onTriggered: {
          webview.url = myUrl+"ausland"
        }
        text: qsTr("International")
      },
      RadialAction {
        id: switzerland
        iconSource: Qt.resolvedUrl("icons/0050-folder-plus.svg")
        onTriggered: {
          webview.url = myUrl+"schweiz"
        }
        text: qsTr("Schweiz")
      },
      RadialAction {
        id: sport
        iconSource: Qt.resolvedUrl("icons/0423-dribbble.svg")
        onTriggered: {
          webview.url = myUrl+"sport"
        }
        text: qsTr("Sport")
      },
      RadialAction {
        id: dasmagazin
        iconSource: Qt.resolvedUrl("icons/0121-quotes-right.svg")
        onTriggered: {
          webview.url = "https://www.dasmagazin.ch"
        }
        text: qsTr("Magazin")
      },
      RadialAction {
        id: sonntagszeitung
        iconSource: Qt.resolvedUrl("icons/sonntagszeitung.svg")
        onTriggered: {
          webview.url = myUrl+"sonntagszeitung"
        }
        text: qsTr("Sonntagszeitung")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Back")
      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }
  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }
  Connections {
    target: window.webview
    onIsFullScreenChanged: window.setFullscreen(window.webview.isFullScreen)
  }

  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
      }
    }
  }
}
