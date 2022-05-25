# TheMailCat)
Скрипт для массовой рассылки email

```bash
git clone https://github.com/tehnosvar/email-newsletter.git
cd email-newsletter

python3 -m venv venv
source venv/bin/activate

pip install pyside2
python main.py

# Для сборки
pip install pyinstaller
pyinstaller --name="TheMailCat" --icon=mailcat.ico --windowed main.py

# Добавить в архив
cd dist
tar -czvf themailcat-linux-amd64.tar.gz TheMailCat
```
    
# Сборки:
Linux   :

Windows :