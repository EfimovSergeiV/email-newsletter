# This Python file uses the following encoding: utf-8
from pathlib import Path
import os, sys, smtplib
import email.message
from time import sleep
from random import randrange

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot, QThread

from email.message import EmailMessage
import smtplib
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

    msg = EmailMessage()
    # msg.set_content(
    # """ Привет мир """
    # )
    asparagus_cid = make_msgid()

    # with open('/home/anon/neuesJahr.html', 'r') as file:
    #     rtemplate = file.read()

    msg.add_alternative(template, subtype='html')

    # Добавить вложение
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
    server.login(msg['From'], password)
    server.sendmail(msg['From'], msg['To'], bytes(msg))
    server.quit()



class Worker(QObject):
    def __init__(self):
        super(Worker, self).__init__()
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

        while self.data:
            if self._isRunning == False:
                break
            mail = self.data.pop()
            
            self.count += 1
            self.counterValue.emit(str(self.count))
            self.sendToEmail.emit(mail)

            send_mail(
                to_email=mail,
                from_mail=self.from_mail,
                theme=self.theme,
                template=self.template,
                smtp_server=self.smtp_server,
                login=self.login,
                password=self.password
            )

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
        self.stop_thread()


    @Slot()
    def run_send_mails(self):
        """ Запускаем поток отправки писем """

        # Создаём экземпляр и помещаем в поток
        self.thread = QThread()
        self.worker = Worker()
        self.worker.moveToThread(self.thread)

        # Передаём данные в поток
        self.worker.data = self.list_mails
        self.worker.count = self.last_count
        self.worker.theme = self.theme
        self.worker.template = self.template
        self.worker.from_mail = self.from_mail
        self.worker.smtp_server = self.smtp_server
        self.worker.login = self.login
        self.worker.password = self.password
        self.worker.timer = self.timer

        self.thread.started.connect(self.worker.handler)
        self.thread.start()

        self.worker.sendToEmail.connect(self.mailSended)
        self.worker.counterValue.connect(self.mailCounter)

        self.worker.returnMails.connect(self.restore_sending)
        self.worker.counterValue.connect(self.progress_bar)
        self.worker.senderComleted.connect(self.stop_thread)


    def stop_thread(self):
        self.worker.stop()
        self.thread.quit()
        # self.thread.wait()



if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    app.setOrganizationName("S20058")
    app.setOrganizationDomain("s2nullnullachtundfunfzig.ru")

    engine = QQmlApplicationEngine()

    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)

    engine.load(os.fspath(Path(__file__).resolve().parent / "frontend/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
