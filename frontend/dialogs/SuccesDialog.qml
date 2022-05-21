import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Dialog {
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
        color: "#5D6973"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Label {
            id: label
            x: 21
            y: 133
            width: 458
            height: 63
            color: "#ffffff"
            text: "Рассылка прошла, цели осчастливлены)"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 16
            font.bold: true
        }

        Label {
            id: helpMess
            x: 8
            y: 374
            width: 484
            height: 18
            visible: false
            text: qsTr("Благодарность за эту программу можно занести вниз в жидком виде, произвольного объёма)")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
            font.bold: true
        }

        Button {
            id: button1
            x: 21
            y: 328
            width: 215
            height: 40
            text: qsTr("Помощь")
            onClicked: helpMess.visible = !helpMess.visible
        }

        Button {
            id: button
            x: 242
            y: 328
            width: 237
            height: 40
            text: "Закрыть программу"
            onClicked: Qt.quit()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9;height:400;width:500}
}
##^##*/
