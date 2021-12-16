### Домашнее задание к занятию "10.03. Grafana"

#### Задание повышенной сложности

>**В части задания 1** не используйте директорию [help](./help) для сборки проекта, самостоятельно разверните grafana, где в 
роли источника данных будет выступать prometheus, а сборщиком данных node-exporter:
>- grafana
>- prometheus-server
>- prometheus node-exporter
>
>За дополнительными материалами, вы можете обратиться в официальную документацию grafana и prometheus.
>
>В решении к домашнему заданию приведите также все конфигурации/скрипты/манифесты, которые вы 
использовали в процессе решения задания.
>
>**В части задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например Telegram или Email
и отправить туда тестовые события.
>
>В решении приведите скриншоты тестовых событий из каналов нотификаций.

Связку устанавливал на виртуальной машине с помощью ansible. Для установки  prometheus использовал роль предложенную в официальной документации https://github.com/cloudalchemy/ansible-prometheus. Для установки grafana и node_exporter добавил в роль простые таски.

main.yml
```yaml
...

- include: install_grafana.yml
  become: true

- include: install_node.yml
  become: true

...  
```

install_grafana.yml
```yaml
---
- name: Install nessesary package
  apt:
    name: apt-transport-https
    state: present
    update_cache: yes

- name: add grafana gpg key
  shell: curl https://packages.grafana.com/gpg.key | sudo apt-key add -

- name: add grafana repo
  apt_repository:
    repo: deb https://packages.grafana.com/oss/deb stable main
    state: present
    filename: grafana

- name: Install grafana
  apt:
    name: grafana
    state: present
    update_cache: yes

- name: Enable and start grafana service
  service:
    name: grafana-server
    enabled: yes
    state: started
```
install_node.yml
```yaml
- name: Download node_exporter
  get_url:
    url: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
  register: download_node
  until: download_node is succeeded

- name: Unpack node_exporter binary
  unarchive:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: "/tmp"
    remote_src: true

- name: Copy node_exporter file to bin
  copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "/usr/local/bin/node_exporter"
    mode: 0755
    remote_src: yes

- name: Copy systemd init file
  template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service

- name: Start node_exporter
  service:
    name: node_exporter
    state: started
    enabled: yes
```

>#### Обязательные задания
>
>##### Задание 1
>Используя директорию [help](./help) внутри данного домашнего задания - запустите связку prometheus-grafana.
>
>Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.
>
>Подключите поднятый вами prometheus как источник данных.
>
>Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.

![grafana.jpg](grafana.jpg)

>#### Задание 2
>Изучите самостоятельно ресурсы:
>- [promql-for-humans](https://timber.io/blog/promql-for-humans/>#cpu-usage-by-instance)
>- [understanding prometheus cpu metrics](https://www.robustperception.io/>understanding-machine-cpu-usage)
>
>Создайте Dashboard и в ней создайте следующие Panels:
>- Утилизация CPU для nodeexporter (в процентах, 100-idle)
```
100 - (avg(rate(node_cpu_seconds_total{job="node",mode="idle"}[5m])) * 100)
```
>- CPULA 1/5/15
```
avg(node_load1) / count(count(node_cpu_seconds_total) by (cpu)) * 100
avg(node_load5) / count(count(node_cpu_seconds_total) by (cpu)) * 100
avg(node_load15) / count(count(node_cpu_seconds_total) by (cpu)) * 100
```
>- Количество свободной оперативной памяти
```
node_memory_MemFree_bytes
```
>- Количество места на файловой системе
```
node_filesystem_avail_bytes{fstype!="tmpfs"}
node_filesystem_size_bytes{fstype!="tmpfs"}-node_filesystem_avail_bytes{fstype!="tmpfs"}

```
>
>Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также >скриншот получившейся Dashboard.

![dashboard.jpg](dashboard.jpg)

>## Задание 3
>Создайте для каждой Dashboard подходящее правило alert (можно обратиться к >первой лекции в блоке "Мониторинг").
>
>Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.

Алерт привязал только к первому графику, т.к. для остальных типов графиков этого сделать нельзя.

![alert.jpg](alert.jpg)


>## Задание 4
>Сохраните ваш Dashboard.
>
>Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".
>
>Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
>
>В решении задания - приведите листинг этого файла.

[my_dashboard.json](my_dashboard.json)