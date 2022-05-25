import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    property string status: null

    id: root
    width: 500
    height: 400
    rightPadding: 0
    bottomPadding: 0
    padding: 0
    leftPadding: 0
    topPadding: 0
    margins: 0
    rightMargin: 0
    bottomMargin: 0
    leftMargin: 0
    topMargin: 0

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 500
        height: 400
        color: "#242424"

        AnimatedImage {
            id: animatedImage
            x: 8
            y: 8
            width: 484
            height: 350
            source: "../content/cat.gif"

            Rectangle {
                color: "#005d6973"
                anchors.fill: parent
                anchors.rightMargin: 0
                anchors.bottomMargin: -34
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Label {
                    id: label
                    x: 8
                    y: 259
                    width: 484
                    height: 63
                    color: "#ffffff"
                    text: root.status
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 23
                    font.bold: true
                }

                Label {
                    id: helpMess
                    x: 0
                    y: 0
                    width: 484
                    height: 26
                    visible: false
                    color: "#ff0000"
                    text: qsTr("Благодарность за эту программу можно занести вниз в жидком виде, произвольного объёма)")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 8
                    font.bold: true
                }

                Button {
                    id: button1
                    x: 8
                    y: 344
                    width: 215
                    height: 40
                    text: qsTr("Помощь")
                    onClicked: helpMess.visible = !helpMess.visible
                }

                Button {
                    id: button
                    x: 239
                    y: 344
                    width: 237
                    height: 40
                    text: "Закрыть программу"
                    onClicked: Qt.quit()
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9;height:400;width:500}
}
##^##*/

