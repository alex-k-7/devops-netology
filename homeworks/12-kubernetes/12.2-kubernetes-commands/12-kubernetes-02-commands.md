### Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

#### Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods


```
PS C:\Users\kosogorskii.as> kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
deployment.apps/hello-node created
PS C:\Users\kosogorskii.as> kubectl scale --replicas=2 deployment/hello-node
deployment.apps/hello-node scaled
PS C:\Users\kosogorskii.as> kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           101s
```

#### Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

```
# создание пользователя
PS C:\Users\kosogorskii.as> kubectl create serviceaccount dev1 
serviceaccount/dev1 created

# yaml файл для создания роли:

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]

# создать роль
PS C:\Users\kosogorskii.as\.kube> kubectl create -f role.yml
role.rbac.authorization.k8s.io/pod-reader created

# привязываем роль к пользователю
PS C:\Users\kosogorskii.as\.kube> kubectl create rolebinding pod-reader-bind --role=pod-reader --serviceaccount=default:dev1 --namespace=default
rolebinding.rbac.authorization.k8s.io/pod-reader-bind created

# yaml файл для создания токена:

apiVersion: v1
kind: Secret
metadata:
  name: dev1-secret
  annotations:
    kubernetes.io/service-account.name: dev1-secret
 type: kubernetes.io/service-account-token

# создание токена
PS C:\Users\kosogorskii.as\.kube> kubectl create -f secret.yml
secret/dev1-secret created
```
далее набрав команду kubectl get secrets, данного токена не увидел
```
PS C:\Users\kosogorskii.as\.kube> kubectl get secrets
NAME                       TYPE                                  DATA   AGE
default-token-f247r        kubernetes.io/service-account-token   3      178m
dev1-token-dlmkt           kubernetes.io/service-account-token   3      62m
```
но обнаружил, что для пользователя dev1 существует токен dev1-token-dlmkt. он создается автоматически при создании serviceaccount? его удалось использовать далее
```
PS C:\Users\kosogorskii.as\.kube> kubectl describe secret/dev1-token-dlmkt
Namespace:    default
Annotations:  kubernetes.io/service-account.name: dev1


Data
====
ca.crt:     1111 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsIm........... 

# добавляем пользователя dev1 в локальный конфиг
kubectl config set-credentials dev1 --token eyJhbGciOiJSUzI1NiIsIm.........

# переключаемся на нового пользователя и пробуем удалить pod
PS C:\Users\kosogorskii.as\.kube> kubectl config set-context minikube --user dev1
Context "minikube" modified.
PS C:\Users\kosogorskii.as\.kube> kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-7567d9fdc9-85svj   1/1     Running   0          111m
hello-node-7567d9fdc9-b9gcp   1/1     Running   0          117m
hello-node-7567d9fdc9-dkt5d   1/1     Running   0          111m
hello-node-7567d9fdc9-n7tj2   1/1     Running   0          111m
hello-node-7567d9fdc9-pbssr   1/1     Running   0          116m
PS C:\Users\kosogorskii.as\.kube> kubectl delete pods/hello-node-7567d9fdc9-pbssr
Error from server (Forbidden): pods "hello-node-7567d9fdc9-pbssr" is forbidden: User "system:serviceaccount:default:dev1" cannot delete resource "pods" in API group "" in the namespace "default"

# пробуем смотреть информацию о поде
PS C:\Users\kosogorskii.as\.kube> kubectl describe pods/hello-node-7567d9fdc9-pbssr
Name:         hello-node-7567d9fdc9-pbssr
Namespace:    default
Priority:     0
Node:         docker-ubuntu/10.129.0.8
Start Time:   Fri, 21 Jan 2022 14:53:52 +0300
Labels:       app=hello-node
              pod-template-hash=7567d9fdc9
Annotations:  <none>
Status:       Running
IP:           172.17.0.4

# смотрим логи
PS C:\Users\kosogorskii.as\.kube> kubectl logs -p  pods/hello-node-7567d9fdc9-pbssr 
Error from server (BadRequest): previous terminated container "echoserver" in pod "hello-node-7567d9fdc9-pbssr" not found
.....

```
#### Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

 ```
PS C:\Users\kosogorskii.as> kubectl scale --replicas=5 deployment/hello-node
deployment.apps/hello-node scaled
PS C:\Users\kosogorskii.as> kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-7567d9fdc9-85svj   1/1     Running   0          9s
hello-node-7567d9fdc9-b9gcp   1/1     Running   0          5m58s
hello-node-7567d9fdc9-dkt5d   1/1     Running   0          9s
hello-node-7567d9fdc9-n7tj2   1/1     Running   0          9s
hello-node-7567d9fdc9-pbssr   1/1     Running   0          5m17s
 ```
