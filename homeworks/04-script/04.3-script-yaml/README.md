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

```python
#!/usr/bin/env python3

import socket, json, yaml

fr = open('srv_ip.txt', 'r')
srv_list = [l.strip() for l in fr]
fr.close()
srv_dict = dict(i.split(' - ') for i in srv_list)
fw = open('srv_ip.txt', 'w')

for key, value in srv_dict.items():
    ip = socket.gethostbyname(key)
    if ip != value:
        print('ERROR ', key, ' IP mismatch: ', value, ' ', ip)
        fw.write(key + ' - ' + ip + '\n')
        srv_dict[key] = ip
    else:
        print(key, ' - ', value)
        fw.write(key + ' - ' + value + '\n')

fw.close()

with open('srv_ip.json', 'w') as tmp:
    tmp.write(json.dumps(srv_dict, indent=2))

with open('srv_ip.yml', 'w') as tmp:
    tmp.write(yaml.dump(srv_dict))
```