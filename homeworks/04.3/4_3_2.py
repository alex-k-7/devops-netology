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