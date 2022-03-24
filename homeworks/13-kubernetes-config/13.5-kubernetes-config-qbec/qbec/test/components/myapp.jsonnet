local p = import '../params.libsonnet';
local params = p.components.myapp;

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "frontend",
      "labels": {
        "app": "frontend"
      }
    },
    "spec": {
      "replicas": params.replicas,
      "selector": {
        "matchLabels": {
          "app": "frontend"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "frontend"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "frontend",
              "image": params.fimage,
              "ports": [
                {
                  "containerPort": params.fport,
                }
              ],
              "env": [
                {
                  "name": "BASE_URL",
                  "value": "http://backend: params.bport",
                }
              ]
            }
          ]
        }
      }
    }
  },

  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": "db"
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "db"
        }
      },
      "serviceName": "db",
      "replicas": params.replicas,
      "template": {
        "metadata": {
          "labels": {
            "app": "db"
          }
        },
        "spec": {
          "terminationGracePeriodSeconds": 10,
          "containers": [
            {
              "name": "db",
              "image": params.dbimage,
              "ports": [
                {
                  "containerPort": params.dbport
                }
              ],
              "env": [
                {
                  "name": "POSTGRES_PASSWORD",
                  "value": "postgres"
                },
                {
                  "name": "POSTGRES_USER",
                  "value": "postgres"
                },
                {
                  "name": "POSTGRES_DB",
                  "value": "news"
                }
              ]
            }
          ]
        }
      }
    }
  },

  {
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "name": "backend",
    "labels": {
      "app": "backend"
    }
  },
  "spec": {
    "replicas": params.replicas,
    "selector": {
      "matchLabels": {
        "app": "backend"
      }
    },
    "template": {
      "metadata": {
        "labels": {
          "app": "backend"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "backend",
            "image": params.bimage,
            "ports": [
              {
                "containerPort": params.bport
              }
            ],
            "env": [
              {
                "name": "DATABASE_URL",
                "value": "postgres://postgres:postgres@db:params.dbport/new"
              }
            ]
          }
        ]
      }
    }
  }
},
  
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "db"
    },
    "spec": {
      "selector": {
        "app": "db"
      },
      "ports": [
        {
          "protocol": "TCP",
          "port": params.dbport,
          "targetPort": params.dbport
        }
      ]
    }
  },
]