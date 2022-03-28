import hvac
client = hvac.Client(
    url='http://10.233.96.120:8200',
    token='SeCrEt'
)
client.is_authenticated()

client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

client.secrets.kv.v2.read_secret_version(
    path='hvac',
)