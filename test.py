# import smtplib
# from email.mime.multipart import MIMEMultipart
# from email.mime.text import MIMEText

# smtp = smtplib.SMTP_SSL('smtp.beget.com', 465)
# smtp.login(user='support@glsvar.ru', password='')

# smtp.sendmail(from_addr="support@glsvar.ru", to_addrs="sys@tehnosvar.ru", msg="Hallo weelt")
# smtp.close()


from email.mime.multipart import MIMEMultipart

from email.mime.text import MIMEText
import smtplib


msg = MIMEMultipart()
message = "Thank you"
password = ""
msg['From'] = "support@glsvar.ru"
msg['To'] = "sys@tehnosvar.ru"
msg['Subject'] = "СЕРВИС ОТПРАВКИ ПИСЕМ"
msg.attach(MIMEText(message, 'plain'))
server = smtplib.SMTP_SSL('smtp.beget.com', 465)
server.login(msg['From'], password)
server.sendmail(msg['From'], msg['To'], msg.as_string())
server.quit()
