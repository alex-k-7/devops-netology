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
