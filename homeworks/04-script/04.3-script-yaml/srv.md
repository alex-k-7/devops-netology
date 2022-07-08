### Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

>1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
>	```json
>   { "info" : "Sample JSON output from our service\t",
>        "elements" :[
>            { "name" : "first",
>            "type" : "server",
>            "ip" : 7175 
>            },
>            { "name" : "second",
>            "type" : "proxy",
>            "ip : 71.78.22.43
>            }
>        ]
>    }
>	```
>  Нужно найти и исправить все ошибки, которые допускает наш сервис

```json
   { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175    
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43" 
            }
        ]
    }
```
В первом элементе указан не IP, а скорее порт.
Во втором у ip не хватало закрвающих кавычек, и сам адрес тоже должен быть в кавычках.

>2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

Добавил в код из прошлого задания по python преобразование в JSON и YAML.
Получилось, что мы просто читаем текстовый файл еще раз и форматируем его в 
файлы JSON и YAML. Пробовал сделать без повторного чтения текстового файла, но не получилось.
Это возможно? Или такой вариант самый оптимальный?

```python
#!/usr/bin/env python3

import socket, json, yaml

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

f = open('srv_ip.txt', 'r')
srv_list = [l.strip() for l in f]
srv_dict = dict(i.split(' - ') for i in srv_list)

with open('srv_ip.json', 'w') as tmp:
     tmp.write(json.dumps(srv_dict, indent=2))

with open('srv_ip.yml', 'w') as tmp:
     tmp.write(yaml.dump(srv_dict))
```
>#### Дополнительное задание (со звездочкой*) - необязательно к выполнению
>Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
>   * Принимать на вход имя файла
>   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
>   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
>   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
>   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
>   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

Доп задание получилось, но не совсем. Почему-то не происходит обработка исключения
в блоке для YAML. Если файл с расширением yml, то исключение не обрабатывается даже 
если там формат json. Не смог (не успел) разобраться и с тем, как вывести строку с 
ошибкой синтаксиса.

```python
#!/usr/bin/env python3

import sys, os, json, yaml

#fname = sys.argv[1]
if len(sys.argv) > 1:
    fname = sys.argv[1]
    fsplit = (os.path.splitext(fname))
    
    if os.path.exists(fname):
        if fname.endswith('.json'):
            with open(fname, 'r') as f:
                try:
                    js = json.load(f)
                    with open(fsplit[0] + '.yml', 'w') as f_yml:
                        f_yml.write(yaml.dump(js))
                    print('File has been converted to YAML format')
                except json.decoder.JSONDecodeError:
                    print('File is not JSON format')
        elif fname.endswith('.yml'):
            with open(fname, 'r') as f:
                try:
                    ym = yaml.safe_load(f)
                    with open(fsplit[0] + '.json', 'w') as f_js:
                        f_js.write(json.dumps(ym, indent=2))
                    print('File has been converted to JSON format')
                except yaml.parser.ParserError:
                    print('File is not YAML format')

        else:
            print('File is not JSON or YAML')

    else:
        print('File not exist')

else:
    print('Enter file name')
```