import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import "../dialogs"
import QtQuick.Extras 1.4

Item {

    Button {
        id: templateFileBtn
        x: 476
        y: 8
        width: 182
        height: 30
        text: qsTr("Шаблон")
        onClicked: templatelFileDialog.visible = true
    }

    Button {
        id: adressFileBtn
        x: 476
        y: 44
        width: 182
        height: 30
        text: qsTr("Список счастливчиков")
        onClicked: adressFileDialog.visible = true
    }

    FileDialog {
        id: templatelFileDialog
        visible: false
        title: "Выберите шаблон html для рассылки"
        folder: shortcuts.home
        nameFilters: [ "HTML files (*.html)", "All files (*)" ]
        onAccepted: {
            templatePath.text = templatelFileDialog.fileUrl.toString()
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    FileDialog {
        id: adressFileDialog
        visible: false
        title: "Файл со списком адресов"
        folder: shortcuts.home
        nameFilters: [ "Text files (*.txt)", "All files (*)" ]
        onAccepted: {
            adressPath.text = adressFileDialog.fileUrls.toString()
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Label {
        id: label
        x: 8
        y: 103
        width: 368
        height: 20
        text: "Параметры SMTP сервера:"
    }

    TextField {
        id: adressPath
        x: 8
        y: 44
        width: 462
        height: 30
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 8
        placeholderText: qsTr("Путь до файла с адресами")
    }

    TextField {
        id: templatePath
        x: 8
        y: 8
        width: 462
        height: 30
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 8
        placeholderText: qsTr("Путь до файла с адресами")
    }


    ComboBox {
        x: 8
        y: 129
        width: 175
        height: 26
        model: [ "Yandex", "Google", "Mail", "Beget", "ProtonMail"]
    }


    Switch {
        id: smtpTimer
        x: 555
        y: 194
        width: 237
        height: 24
        text: "Наёбывать SMTP сервер"
        onClicked: console.log(smtpTimer.position)
    }

    TextField {
        id: textField1
        x: 189
        y: 193
        width: 281
        height: 25
        placeholderText: qsTr("Пароль")
    }

    TextField {
        id: textField
        x: 189
        y: 161
        width: 281
        height: 25
        placeholderText: qsTr("Логин")
    }


    TextField {
        id: textField2
        x: 189
        y: 129
        width: 281
        height: 26
        placeholderText: qsTr("yuor-adress@mailname.ru")
    }

    ProgressBar {
        id: progressBar
        x: 8
        y: 301
        width: 784
        height: 14
        value: 0.3
    }

    ScrollView {
        id: scrollView
        x: 8
        y: 314
        width: 784
        height: 157

        TextArea {
            id: textArea
            x: -10
            y: -6
            width: 784
            height: 157
            placeholderText: qsTr("Прогресс рассыки")
        }
    }

    Label {
        id: label1
        x: 8
        y: 277
        width: 132
        height: 18
        text: "Найдено адресов:"
    }

    Label {
        id: addressCount
        x: 146
        y: 277
        width: 230
        height: 18
        text: qsTr("0")
    }

    Label {
        id: label3
        x: 382
        y: 277
        width: 119
        height: 18
        text: qsTr("Осчастливили:")
    }

    Label {
        id: happyValue
        x: 502
        y: 277
        width: 290
        height: 18
        text: qsTr("0")
    }

    SuccesDialog {
        id: success
        anchors.centerIn: parent
    }

    DelayButton {
        id: sendMessages
        x: 684
        y: 8
        width: 108
        height: 99
        text: "Запуск"
        onActivated: success.open()
    }




}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:480;width:800}
}
##^##*/
