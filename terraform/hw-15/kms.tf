resource "yandex_kms_symmetric_key" "key-a" {
    name              = "example-symetric-key"
    description       = "key for bucket storage"
    default_algorithm = "AES_128"
    rotation_period   = "8760h"
}