### Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

>Бывает, что 
>* общедоступная документация по терраформ ресурсам не всегда достоверна,
>* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
>* понадобиться использовать провайдер без официальной документации,
>* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   
>
>## Задача 1. 
>Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
>[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
>Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  
>
>1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
>гитхабе.   

resource - https://github.com/hashicorp/terraform-provider-aws/blob/1776cbf7cac4a821fcc3aebe06fc52845aab4e11/aws/provider.go#L394

data_source - https://github.com/hashicorp/terraform-provider-aws/blob/8c20a31090cb4495ec9397aa50d3ff308426742a/aws/provider.go#L186

>1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
>    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.

name_prefix 
```text
Schema: map[string]*schema.Schema{
			"name": {
				Type:          schema.TypeString,
				Optional:      true,
				ForceNew:      true,
				Computed:      true,
				ConflictsWith: []string{"name_prefix"},
				ValidateFunc:  validateSQSQueueName,
			},
```
 
>    * Какая максимальная длина имени? 

80 символов.

>   * Какому регулярному выражению должно подчиняться имя? 

^[0-9A-Za-z-_]+$