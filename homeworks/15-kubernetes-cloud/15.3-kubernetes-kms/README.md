>### Домашнее задание к занятию 15.3 >"Безопасность в облачных провайдерах"
>Используя конфигурации, выполненные в рамках >предыдущих домашних заданиях, нужно добавить >возможность шифрования бакета.
>
>---
>#### Задание 1. Яндекс.Облако (обязательное к >выполнению)
>1. С помощью ключа в KMS необходимо >зашифровать содержимое бакета:
>- Создать ключ в KMS,

```
resource "yandex_kms_symmetric_key" "key-a" {
    name              = "example-symetric-key"
    description       = "key for bucket storage"
    default_algorithm = "AES_128"
    rotation_period   = "8760h"
}
```
>- С помощью ключа зашифровать содержимое >бакета, созданного ранее.

```
resource "yandex_storage_bucket" "test" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "aks-netology-bucket"
    acl    = "public-read"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = yandex_kms_symmetric_key.key-a.id
                sse_algorithm     = "aws:kms"
            }
        }
    }
}
```

[Ссылка](https://github.com/alex-k-7/devops-netology/tree/main/terraform/hw-15) на файлы Terraform. 



