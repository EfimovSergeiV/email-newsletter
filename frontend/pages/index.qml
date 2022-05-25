import QtQuick 2.0
import QtCharts 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Extras 1.4
import "../dialogs"

Item {

    Button {
        id: templateFileBtn
        x: 610
        y: 8
        width: 182
        height: 30
        text: qsTr("Шаблон")
        font.bold: false
        onClicked: templateFileDialog.visible = true
    }

    Button {
        id: adressFileBtn
        x: 610
        y: 44
        width: 182
        height: 30
        text: qsTr("Список счастливчиков")
        font.bold: false
        onClicked: adressFileDialog.visible = true
    }

    FileDialog {
        id: templateFileDialog
        visible: false
        title: "Выберите шаблон html для рассылки"
        folder: shortcuts.home
        nameFilters: ["HTML files (*.html)", "All files (*)"]
        onAccepted: {
            templatePath.text = templateFileDialog.fileUrl.toString()
            backend.set_template(templateFileDialog.fileUrls)
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
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        onAccepted: {
            adressPath.text = adressFileDialog.fileUrls.toString()
            backend.open_mails_file(adressFileDialog.fileUrls)
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Label {
        id: label
        x: 8
        y: 96
        width: 368
        height: 20
        color: "#ffffff"
        text: "Параметры SMTP (SSL only) сервера :"
    }

    TextField {
        id: adressPath
        x: 8
        y: 44
        width: 596
        height: 30
        horizontalAlignment: Text.AlignLeft
        readOnly: true
        font.pointSize: 8
        placeholderText: qsTr("Путь до файла с адресами")
    }

    TextField {
        id: templatePath
        x: 8
        y: 8
        width: 596
        height: 30
        horizontalAlignment: Text.AlignLeft
        readOnly: true
        font.pointSize: 8
        placeholderText: qsTr("Путь до файла с шаблоном")
    }

    ComboBox {
        id: smtpServer
        x: 8
        y: 122
        width: 175
        height: 30
        model: ["Yandex", "Google", "Mail", "Beget"]
    }

    Switch {
        id: smtpTimer
        x: 552
        y: 122
        width: 68
        height: 24
        onClicked: backend.smtp_timer(smtpTimer.position)
    }

    TextField {
        id: textField1
        x: 189
        y: 194
        echoMode: "Password"
        width: 331
        height: 30
        placeholderText: qsTr("...и пароль от него")
    }

    TextField {
        id: textField
        x: 189
        y: 158
        width: 331
        height: 30
        placeholderText: qsTr("Логин от ящика выше")
    }

    TextField {
        id: textField2
        x: 189
        y: 122
        width: 331
        height: 30
        placeholderText: qsTr("yuor-email-adress@mailname.ru")
    }

    Rectangle {
        id: rectangle
        x: 8
        y: 315
        width: 784
        height: 157
        color: "#e3e3e3"

        ScrollView {
            id: scrollView
            x: 0
            y: 0
            width: 784
            height: 157

            TextArea {
                id: textArea
                x: -4
                y: -6
                width: 778
                height: 157
                color: "#0b0b0b"
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                hoverEnabled: true
                placeholderText: "лог email рассылки"
                font.bold: false
                font.pointSize: 10

                placeholderTextColor: "#1d1d1d"
                readOnly: true
            }
        }
    }

    TextField {
        id: textField3
        x: 8
        y: 230
        width: 512
        height: 30
        placeholderText: qsTr("Тема письма")
    }

    ProgressBar {
        id: progressBar
        x: 8
        y: 301
        width: 784
        height: 14
        value: 0.0
    }

    Label {
        id: label1
        x: 8
        y: 277
        width: 132
        height: 18
        color: "#ffffff"
        text: "Найдено адресов:"
        font.bold: true
    }

    Label {
        id: addressCount
        x: 146
        y: 277
        width: 113
        height: 18
        color: "#ffffff"
        text: qsTr("0")
        font.bold: true
    }

    Label {
        id: label3
        x: 295
        y: 277
        width: 119
        height: 18
        color: "#ffffff"
        text: qsTr("Осчастливили:")
        font.bold: true
    }

    Label {
        id: happyValue
        x: 420
        y: 277
        width: 138
        height: 18
        color: "#ffffff"
        text: qsTr("0")
        font.bold: true
    }

    SuccesDialog {
        id: success
        anchors.centerIn: parent
    }

    Button {
        id: button1
        x: 635
        y: 255
        width: 51
        height: 40
        text: qsTr("II")
        font.bold: true
        onClicked: {
            backend.stop_sending()
        }
    }

    Button {
        id: runnerBtn
        x: 692
        y: 255
        text: "Запуск"
        font.bold: true
        enabled: true
        autoExclusive: false
        //        checked: false
        //        checkable: true
        onClicked: {
            backend.set_from_mail(textField2.text)
            backend.set_password(textField1.text)
            backend.set_login(textField.text)
            backend.set_mail_theme(textField3.text)
            backend.set_smtp_server(smtpServer.currentValue)
            backend.run_send_mails()
        }
    }

    Connections {
        target: backend

        function onMailsFinded(value) {
            addressCount.text = value
        }

        function onMailSended(text) {
            textArea.text = text + '\n' + textArea.text
        }

        function onMailCounter(value) {
            happyValue.text = value
        }

        function onDissableRunner() {
            runnerBtn.enabled = false
        }

        function onProgressBar(value) {
            progressBar.value = value
        }
    }

    Label {
        id: label2
        x: 620
        y: 144
        width: 173
        height: 14
        color: "#ffffff"
        text: "(Как правило банят, если не наёбывать)"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 7
    }

    Label {
        id: label4
        x: 620
        y: 122
        width: 172
        height: 24
        color: "#ffffff"
        text: qsTr("Наёбывать SMTP сервер")
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.bold: true
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:480;width:800}
}
##^##*/

