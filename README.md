# devops-netology
one

# terraform .gitignore
- **/.terraform/* - директория .terraform находящаяся в любых директориях и ее поддиректории.
- *.tfstate - все файлы с расширением .tfstate
- *.tfvars - все файлы с расширением .tfvars
- *.tfstate.* - все файлы имеющие в названии .tfstate.
- crash.log, override.tf, override.tf.json, .terraformrc, terraform.rc - конкретные файлы
- *_override.tf - все файлы заканчивающиеся на _override.tf
- *_override.tf.json - все файлы заканчивающиеся на _override.tf.json