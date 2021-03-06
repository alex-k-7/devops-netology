### Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

>1. Есть скрипт:
>	```python
>   #!/usr/bin/env python3
>	a = 1
>	b = '2'
>	c = a + b
>	```
>	* Какое значение будет присвоено переменной c?
>	* Как получить для переменной c значение 12?
>   * Как получить для переменной c значение 3?

* Здесь для переменной "с" происходит попытка сложения целочисленной переменной со строчной,
  поэтому python выдаст ошибку.
* b = 11
* b = 2 или b = int(b)

>2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
>
>	```python
>   #!/usr/bin/env python3
>
>    import os
>
>	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
>	result_os = os.popen(' && '.join(bash_command)).read()
>   is_change = False
>	for result in result_os.split('\n'):
>        if result.find('modified') != -1:
>            prepare_result = result.replace('\tmodified:   ', '')
>            print(prepare_result)
>            break
>
>	```

#### У меня скрипт выводит полный путь. Что-то неверно? Сделал комменты в коде.
```python
#!/usr/bin/env python3

import os

cd_dir = 'cd ~/netology/sysadm-homeworks'
result_os = os.popen(cd_dir + ' && ' + 'git status').read()
fulldir = (os.popen(cd_dir + ' && ' + 'pwd').read().rstrip() + '/') #полный путь до файлов
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', fulldir) #подстановка полного пути до файлов
        print(prepare_result)
```

>3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

#### Полный путь здесь также уже был. Проверку является ли директория репозиторием добавил. Мне казалось, что она не нужна т.к. git status сам делает такую проверку и выдает соответствующее сообщение.

```python
#!/usr/bin/env python3

import os, sys

if len(sys.argv) > 1:
    enter_dir = sys.argv[1]
else:
    enter_dir = '~/netology/sysadm-homeworks'

fulldir = (os.popen('cd ' + enter_dir + ' && pwd').read().rstrip() + '/')
gitstatus = os.popen('cd ' + enter_dir + ' && git status 2>/dev/null').read()

if os.path.isdir(fulldir + '.git'):
    for result in gitstatus.split('\n'):
        if result.find('modified') != -1:
            modfiles = result.replace('\tmodified:   ', fulldir)
            print(modfiles)
else:
    print('Directory is not a git repository')
```

>4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

Здесь у меня получилось так:
существует файл с url сервиса и его ip. Скрипт считывает url из файла, делает по нему запрос для
получения текущего ip, сравнивает его с ip из файла. Далее выводится ошибка, если ip 
поменялся, или url - ip из файла, если изменений не было. Также происходит запись в файл либо 
новых url - ip, либо старых. 

```python
#!/usr/bin/env python3

import socket

f = open('srv_ip.txt', 'r')
srv_list = [l.strip() for l in f]
srv_dict = dict(i.split(' - ') for i in srv_list)
f = open('srv_ip.txt', 'w')

for key, value in srv_dict.items():
    ip = socket.gethostbyname(key)
    if ip != value:
        print('ERROR ', key, ' IP mismatch: ', value, ' ', ip)
        f.write(key + ' - ' + ip + '\n')
    else:
        print(key, ' - ', value)
        f.write(key + ' - ' + value + '\n')

f.close()

```