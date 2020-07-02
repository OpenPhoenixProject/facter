# frozen_string_literal: true

module Facts
  module Macosx
    class DhcpServers
      FACT_NAME = 'dhcp_servers'

      def call_the_resolver
        fact_value = construct_addresses_hash
        fact_value = !fact_value || fact_value.empty? ? nil : fact_value
        Facter::ResolvedFact.new(FACT_NAME, fact_value, :legacy)
      end

      private

      def construct_addresses_hash
        primary_dhcp = Facter::Resolvers::Macosx::Networking.resolve(:dhcp)
        interfaces = Facter::Resolvers::Macosx::Networking.resolve(:interfaces)
        return unless interfaces

        servers = { system: primary_dhcp }
        interfaces&.each { |interface_name, info| servers[interface_name] = info[:dhcp] if info[:dhcp] }
        servers
      end
    end
  end
end
