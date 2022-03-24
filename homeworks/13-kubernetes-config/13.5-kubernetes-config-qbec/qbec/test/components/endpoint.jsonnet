{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "external-svc"
  },
  "spec": {
    "ports": [
      {
        "name": "web",
        "protocol": "TCP",
        "port": 80,
        "targetPort": 80
      }
    ]
  }
}

{
  "kind": "Endpoints",
  "apiVersion": "v1",
  "metadata": {
    "name": "external-svc"
  },
  "subsets": [
    {
      "addresses": [
        {
          "ip": "3.209.99.235"
        }
      ],
      "ports": [
        {
          "port": 80,
          "name": "web"
        }
      ]
    }
  ]
}