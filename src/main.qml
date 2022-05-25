import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "./controls"

Window {
    id: mainWindow
    width: 800
    height: 510
    minimumWidth: 800
    minimumHeight: 510
    maximumWidth: 800
    maximumHeight: 510

    flags: Qt.Window | Qt.FramelessWindowHint

    visible: true
    title: qsTr("Рассылка электронной почты")

    Rectangle {
        id: rectangle
        color: "#aebfcd"
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            height: 30
            color: "#1f1f1f"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            DragHandler {
                onActiveChanged: if(active){
                                     mainWindow.startSystemMove()
                                     internal.ifMaximizedWindowRestore()
                                 }
            }
            Label {
                id: label
                height: 30
                color: "#ebebeb"
                text: qsTr("TheMailCat - массовая рассылка email")
                anchors.left: parent.left
                anchors.right: rowBtns.left
                anchors.top: parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                anchors.rightMargin: 6
                anchors.leftMargin: 0
                anchors.topMargin: 0
            }

            Row {
                id: rowBtns
                x: 740
                width: 60
                height: 30
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.rightMargin: 0

                TopBarButton{
                    id: btnMinimize
                    btnIconSource: "./content/minimize_icon.svg"
                    onClicked: {
                        mainWindow.showMinimized()
                        internal.restoreMargins()
                    }
                }

//                TopBarButton {
//                    id: btnMaximizeRestore
//                    btnIconSource: "./content/maximize_icon.svg"
//                    onClicked: internal.maximizeRestore()
//                }

                TopBarButton {
                    id: btnClose
                    btnColorClicked: "#ff007f"
                    btnIconSource: "./content/close_icon.svg"
                    onClicked: mainWindow.close()
                }
            }

        }

        Image {
            id: image
            x: 0
            y: 30
            width: 800
            height: 480
            source: "./content/bg.png"
            fillMode: Image.PreserveAspectFit
        }
        StackView {
            id: stackView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rectangle1.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.bottomMargin: -30
            anchors.leftMargin: 0
            anchors.topMargin: 0
            initialItem: Qt.resolvedUrl("pages/index.qml")
            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 100
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 100
                }
            }
        }
    }

    //    flags: Qt.Window | Qt.FramelessWindowHint
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:4}D{i:2}
}
##^##*/

