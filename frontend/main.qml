import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 800
    height: 480

    minimumWidth: 800
    minimumHeight: 480

    maximumWidth: 800
    maximumHeight: 480

    visible: true
    title: qsTr("Рассылка электронной почты")

    Rectangle {
        id: rectangle
        color: "#aebfcd"
        anchors.fill: parent

        StackView {
            id: stackView
            anchors.fill: parent
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

