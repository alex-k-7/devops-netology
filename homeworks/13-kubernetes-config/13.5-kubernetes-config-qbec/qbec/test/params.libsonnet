
// this file returns the params for the current qbec environment
local env = std.extVar('qbec.io/env');
local base = import './environments/base.libsonnet';
local default = import './environments/default.libsonnet';

local prod = default {
  components +: {
    myapp +: {
      indexData: 'myapp prod from params\n',
      replicas: 3,
    },
  }
};

local paramsMap = {
  _: base,
  default: default,
  stage: default,
  prod: prod,
};

if std.objectHas(paramsMap, env) then paramsMap[env] else error 'environment ' + env + ' not defined in ' + std.thisFile