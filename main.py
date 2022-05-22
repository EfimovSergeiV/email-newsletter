# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
from time import sleep

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot, QThread



class MailSender(QObject):
    def __init__(self):
        super(MailSender, self).__init__()
        self.data = None
        self._isRunning = True


    counterValue = Signal(str)
    sendToEmail = Signal(str)
    senderComleted = Signal()

    count = 0

    def task(self):
        """ Отправка писем """
        print(self.data)
        for mail in self.data:
            if self._isRunning == False:
                break
            
            self.count += 1
            self.counterValue.emit(str(self.count))
            self.sendToEmail.emit(mail)

            sleep(0.5)
        self.senderComleted.emit()

    def stop(self):
        print("def stop is working")
        self._isRunning = False



class Backend(QObject):
    """ Не забыть валидировать адреса и уведомлять об ошибках """
    mailsFinded = Signal(str)
    mailSended = Signal(str)
    mailCounter = Signal(str)
    dissableRunner = Signal()
    progressBar = Signal(float)


    list_mails = []
    
    @Slot(str)
    def open_mails_file(self, path):
        """ Открываем файл на чтение и извлекаем адреса почтовых ящиков """
        print("find_mails_path: " + path[7:])
        with open(path[7:], 'r') as file:
            list_mails = file.read().lower().splitlines()
            self.mailsFinded.emit(str(len(list_mails)))
            self.list_mails = list_mails
            print(list_mails)


    def progress_bar(self, value):
        """ Чёт я тут не понял математики, но Copilot виднее"""

        progress = int(int(value) / (len(self.list_mails) / 100)) / 100
        self.progressBar.emit(progress)
        
    

    @Slot()
    def stop_sending(self):
        """ Останавливаем поток отправки писем """
        print("stop_sending")
        self.stop_thread()


    @Slot()
    def run_send_mails(self):
        """ Запускаем поток отправки писем """

        self.thread = QThread()
        self.worker = MailSender()
        self.worker.moveToThread(self.thread)

        self.worker.data = self.list_mails
        
        self.thread.started.connect(self.worker.task)
        self.thread.start()

        self.worker.sendToEmail.connect(self.mailSended)
        self.worker.counterValue.connect(self.mailCounter)
        self.worker.counterValue.connect(self.progress_bar)

        self.worker.senderComleted.connect(self.stop_thread)


    def stop_thread(self):
        self.worker.stop()
        self.thread.quit()
        # self.thread.wait()



if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "frontend/main.qml"))

    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
