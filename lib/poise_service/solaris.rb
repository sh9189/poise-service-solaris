#
# Cookbook: poise-service-solaris
# License: Apache 2.0
#
# Copyright 2015, Noah Kantrowitz
# Copyright 2015, Bloomberg Finance L.P.
#

module PoiseService
  # A plugin for poise-service to manage Solaris service
  # @since 1.0.0
  module Solaris
    autoload :Provider, 'poise_service/solaris/provider'
    autoload :VERSION, 'poise_service/solaris/version'
  end
end
