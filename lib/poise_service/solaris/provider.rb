#
# Cookbook: poise-service-solaris
# License: Apache 2.0
#
# Copyright 2015, Noah Kantrowitz
# Copyright 2015, Bloomberg Finance L.P.
#

require 'chef/mash'

require 'poise_service/error'
require 'poise_service/service_providers/base'

module PoiseService
  module ServiceProviders
    # Poise-service provider for Solaris.
    # @since 1.0.0
    class SolarisService < Base
      include Chef::Mixin::ShellOut
      provides(:solaris_service)

      def self.provides_auto?(node, _)
        node['platform_family'] == 'solaris2'
      end

      # Parse the PID from `svcs -p <name>` output.
      # @return [Integer]
      def pid
        service = shell_out!("svcs -p #{@new_resource.service_name}").stdout
        service.split(' ')[-1].to_i
      end

      private

      def create_service
        Chef::Log.debug("Creating solaris service #{new_resource.service_name}")

        template "/lib/svc/manifest/site/#{new_resource.service_name}.xml" do
          source 'manifest.xml.erb'
          verify 'svccfg validate %{file}'
          notifies :run, 'execute[load service manifest]', :immediately
        end

        execute 'load service manifest' do
          action :nothing
          command 'svcadm restart manifest-import'
        end
      end

      def destroy_service
        Chef::Log.debug("Destroying solaris service #{new_resource.service_name}")

        file "/lib/svc/manifest/site/#{new_resource.service_name}.xml" do
          action :delete
          notifies :run, 'execute[load service manifest]', :immediately
        end

        execute 'load service manifest' do
          action :nothing
          command 'svcadm restart manifest-import'
        end
      end

      def service_provider
        super.tap do |r|
          r.provider(Chef::Provider::Service::Solaris)
        end
      end
    end
  end
end
