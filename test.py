from email.message import EmailMessage
import smtplib
from email.utils import make_msgid
import imghdr



msg = EmailMessage()
msg.set_content(
""" Привет мир """
)
asparagus_cid = make_msgid()

with open('/home/anon/neuesJahr.html', 'r') as file:
    template = file.read()


msg.add_alternative(template, subtype='html')

# Добавить вложение
# with open('/home/anon/neuesJahr.jpg', 'rb') as file:
#     msg.get_payload()[1].add_related(file.read(), 'image', 'jpeg', cid=asparagus_cid)

# with open('/home/anon/neuesJahr.jpg', 'rb') as file:
#     img_data = file.read()
#     msg.add_attachment(img_data, maintype='image', subtype=imghdr.what(None, img_data), filename='neuesJahr.jpg')

password = ""
msg['From'] = "support@glsvar.ru"
msg['To'] = "sys@tehnosvar.ru"
msg['Subject'] = "СЕРВИС ОТПРАВКИ ПИСЕМ"


server = smtplib.SMTP_SSL('smtp.beget.com', 465)
server.login(msg['From'], password)
server.sendmail(msg['From'], msg['To'], bytes(msg))
server.quit()
