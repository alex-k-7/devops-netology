// Create SA
resource "yandex_iam_service_account" "sa" {
    name      = "sa-for-bucket"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
    folder_id = var.FOLDER_ID
    role      = "storage.editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa.id
    description        = "static access key for bucket"
}

// Use keys to create bucket
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

// Add picture to bucket
resource "yandex_storage_object" "object-1" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "aks-netology-bucket"
    key = "pic-1"
    source = "pic.jpg"
}