# This Python file uses the following encoding: utf-8
from pathlib import Path
import os, sys, smtplib
from socket import timeout
import email.message
from time import sleep
from random import randrange

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot, QThread

from email.message import EmailMessage
import smtplib
import socket
from email.utils import make_msgid


smtp_servers = {
    "Yandex": "smtp.yandex.ru",
    "Google": "smtp.gmail.com",
    "Mail": "smtp.mail.ru",
    "Beget": "smtp.beget.com",
}


def send_mail(from_mail, to_email, theme, template, smtp_server, login, password):
    print(f"""
from_mail: {from_mail}
to_email: {to_email}
theme: {theme}
smtp_server: {smtp_server}
login: {login}
password: {password}
    """)
    try:
        socket.setdefaulttimeout(120)
        msg = EmailMessage()
        msg.add_alternative(template, subtype='html')    

        # #Добавить вложение
        # with open('/home/anon/neuesJahr.jpg', 'rb') as file:
        #     msg.get_payload()[1].add_related(file.read(), 'image', 'jpeg', cid=asparagus_cid)

        # with open('/home/anon/neuesJahr.jpg', 'rb') as file:
        #     img_data = file.read()
        #     msg.add_attachment(img_data, maintype='image', subtype=imghdr.what(None, img_data), filename='neuesJahr.jpg')

        password = password
        msg['From'] = from_mail
        msg['To'] = to_email
        msg['Subject'] = theme


        server = smtplib.SMTP_SSL(smtp_server, 465)
        print("Логинимся")
        server.login(msg['From'], password)
        print("Отправляем письмо")
        server.sendmail(msg['From'], msg['To'], bytes(msg))
        server.quit()
        return True
    except:
        print("Ошибка отправки письма")
        return False



class SenderWorker(QObject):
    def __init__(self):
        super(SenderWorker, self).__init__()
        self.data = None
        self.count = None
        self._isRunning = True

        self.theme = None
        self.template = None
        self.from_mail = None
        self.smtp_server = None
        self.login = None
        self.password = None
        self.timer = None


    counterValue = Signal(str)
    sendToEmail = Signal(str)
    senderComleted = Signal()
    returnMails = Signal(list)
    

    def handler(self):
        """ Отправка писем """

        while self.data and self._isRunning:
            mail = self.data.pop()
            
            self.count += 1
            sending = send_mail(
                to_email=mail,
                from_mail=self.from_mail,
                theme=self.theme,
                template=self.template,
                smtp_server=self.smtp_server,
                login=self.login,
                password=self.password
            )

            status = "УСПЕШНО" if sending else "ОШИБКА"
            self.counterValue.emit(str(self.count))
            self.sendToEmail.emit(f"{ str(status) }\t { mail }")

            # Пауза между отправкой писем
            if self.timer == 1:
                sleep(randrange(10, 20))

        self.senderComleted.emit()

    def stop(self):
        self.returnMails.emit(self.data)
        self._isRunning = False
        print("MESSAGE: ПРЕРЫВАНИЕ ПОТОКА")


class Backend(QObject):
    """ Не забыть валидировать адреса и уведомлять об ошибках """
    mailsFinded = Signal(str)
    mailSended = Signal(str)
    mailCounter = Signal(str)
    dissableRunner = Signal()
    progressBar = Signal(float)
    errorSignal = Signal(str)

    theme = None
    template = None
    from_mail = None
    smtp_server = None
    login = None
    password = None
    timer = None

    list_mails = []
    len_mails = 0
    last_count = 0


    def progress_bar(self, value):
        """ Расчёт прогресса статус бара """
        progress = int(int(value) / (self.len_mails / 100)) / 100
        self.progressBar.emit(progress)
        self.last_count = int(value)


    def restore_sending(self, list_mails):
        """ Восстанавливаем отправку писем """
        self.list_mails = list_mails

    def success_sending(self):
        """ Отправка писем завершена """
        self.errorSignal.emit("Рассылка вроде прошла")


    @Slot(str)
    def open_mails_file(self, path):
        """ Открываем файл на чтение и извлекаем адреса почтовых ящиков """
        with open(path[7:], 'r') as file:
            list_mails = file.read().lower().splitlines()
            self.len_mails = len(list_mails)
            self.mailsFinded.emit(str(len(list_mails)))
            self.list_mails = list_mails

    @Slot(str)
    def set_mail_theme(self, theme):
        """ Устанавливаем тему письма """
        self.theme = theme

    @Slot(str)
    def set_template(self, template):
        """ Записываем шаблон письма """
        with open(template[7:], 'r') as file:
            self.template = file.read()


    @Slot(str)
    def set_from_mail(self, from_mail):
        """ Записываем от кого письмо """
        self.from_mail = from_mail

    @Slot(str)
    def set_smtp_server(self, smtp_server):
        """ Записываем почтовый сервер """
        self.smtp_server = smtp_servers[smtp_server]


    @Slot(str)
    def set_login(self, login):
        """ Записываем логин для авторизации """
        self.login = login


    @Slot(str)
    def set_password(self, password):
        """ Записываем пароль для авторизации """
        self.password = password

    @Slot(int)
    def smtp_timer(self, value):
        """ Отправка писем по таймеру """
        self.timer = value


    @Slot()
    def stop_sending(self):
        """ Останавливаем поток отправки писем """
        print("Пробуем остановить поток")
        self.test = False
        self.sending_worker.stop()
        self.sending_thread.quit()


    @Slot()
    def run_send_mails(self):
        """ Запускаем поток отправки писем """

        if None not in (self.list_mails, self.theme, self.template, self.from_mail, self.smtp_server, self.login, self.password):
            # Создаём экземпляр и помещаем в поток
            self.sending_thread = QThread()
            self.sending_worker = SenderWorker()
            self.sending_worker.moveToThread(self.sending_thread)

            # Передаём данные в поток
            self.sending_worker.data = self.list_mails
            self.sending_worker.count = self.last_count
            self.sending_worker.theme = self.theme
            self.sending_worker.template = self.template
            self.sending_worker.from_mail = self.from_mail
            self.sending_worker.smtp_server = self.smtp_server
            self.sending_worker.login = self.login
            self.sending_worker.password = self.password
            self.sending_worker.timer = self.timer

            self.sending_thread.started.connect(self.sending_worker.handler)
            
            self.sending_worker.sendToEmail.connect(self.mailSended)
            self.sending_worker.counterValue.connect(self.mailCounter)

            self.sending_worker.returnMails.connect(self.restore_sending)
            self.sending_worker.counterValue.connect(self.progress_bar)
            self.sending_worker.senderComleted.connect(self.success_sending)
            self.sending_worker.senderComleted.connect(self.stop_sending)
                
            self.sending_thread.start()
        else:
            self.errorSignal.emit("Не все поля заполнены")



if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    app.setOrganizationName("S20058")
    app.setOrganizationDomain("s2nullnullachtundfunfzig.ru")

    engine = QQmlApplicationEngine()

    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)

    engine.load(os.fspath(Path(__file__).resolve().parent / "src/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
