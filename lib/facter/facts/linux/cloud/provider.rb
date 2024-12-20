# frozen_string_literal: true

module Facts
  module Linux
    module Cloud
      class Provider
        FACT_NAME = 'cloud.provider'

        def call_the_resolver
          provider = case Facter::Util::Facts::Posix::VirtualDetector.platform
                     when 'hyperv'
                       metadata = Facter::Resolvers::Az.resolve(:metadata)
                       'azure' unless metadata.nil? || metadata.empty?
                     when 'kvm', 'xen', 'xenhvm'
                       metadata = Facter::Resolvers::Ec2.resolve(:metadata)
                       'aws' unless metadata.nil? || metadata.empty?
                     when 'gce'
                       metadata = Facter::Resolvers::Gce.resolve(:metadata)
                       'gce' unless metadata.nil? || metadata.empty?
                     end

          Facter::ResolvedFact.new(FACT_NAME, provider)
        end
      end
    end
  end
end
