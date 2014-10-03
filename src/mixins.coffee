_ = require 'lodash'

deep = (value, other) -> _.merge value, other, deep

_.mixin
  defaultsDeep: _.partialRight _.merge, deep
