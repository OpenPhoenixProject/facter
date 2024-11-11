# frozen_string_literal: true

describe Facts::Linux::Cloud::Provider do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Linux::Cloud::Provider.new }

    context 'when on hyperv' do
      before do
        allow(Facter::Resolvers::Az).to receive(:resolve).with(:metadata).and_return(value)
        allow(Facter::Util::Facts::Posix::VirtualDetector).to receive(:platform).and_return('hyperv')
      end

      context 'when az_metadata exists' do
        let(:value) { { 'some' => 'fact' } }

        it 'returns azure as cloud.provider' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: 'azure')
        end
      end

      context 'when az_metadata does not exist' do
        let(:value) { {} }

        it 'returns nil' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: nil)
        end
      end
    end

    context 'when on a physical machine' do
      before do
        allow(Facter::Util::Facts::Posix::VirtualDetector).to receive(:platform).and_return(nil)
      end

      it 'returns nil' do
        expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
          have_attributes(name: 'cloud.provider', value: nil)
      end
    end

    describe 'when on kvm' do
      before do
        allow(Facter::Resolvers::Ec2).to receive(:resolve).with(:metadata).and_return(value)
        allow(Facter::Util::Facts::Posix::VirtualDetector).to receive(:platform).and_return('kvm')
      end

      describe 'Ec2 data exists and aws fact is set' do
        let(:value) { { 'some' => 'fact' } }

        it 'Testing things' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: 'aws')
        end
      end

      context 'when Ec2 data does not exist nil is returned' do
        let(:value) { {} }

        it 'returns nil' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: nil)
        end
      end
    end

    describe 'when on xen' do
      before do
        allow(Facter::Resolvers::Ec2).to receive(:resolve).with(:metadata).and_return(value)
        allow(Facter::Util::Facts::Posix::VirtualDetector).to receive(:platform).and_return('xen')
      end

      describe 'Ec2 data exists and aws fact is set' do
        let(:value) { { 'some' => 'fact' } }

        it 'Testing things' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: 'aws')
        end
      end

      context 'when Ec2 data does not exist nil is returned' do
        let(:value) { {} }

        it 'returns nil' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: nil)
        end
      end
    end

    describe 'when on xenhvm' do
      before do
        allow(Facter::Resolvers::Ec2).to receive(:resolve).with(:metadata).and_return(value)
        allow(Facter::Util::Facts::Posix::VirtualDetector).to receive(:platform).and_return('xenhvm')
      end

      describe 'Ec2 data exists and aws fact is set' do
        let(:value) { { 'some' => 'fact' } }

        it 'Testing things' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: 'aws')
        end
      end

      context 'when Ec2 data does not exist nil is returned' do
        let(:value) { {} }

        it 'returns nil' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: nil)
        end
      end
    end

    describe 'when on gce' do
      before do
        allow(Facter::Resolvers::Gce).to receive(:resolve).with(:metadata).and_return(value)
        allow(Facter::Util::Facts::Posix::VirtualDetector).to receive(:platform).and_return('gce')
      end

      describe 'and the "gce" fact has content' do
        let(:value) { { 'some' => 'metadata' } }

        it 'resolves a provider of "gce"' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: 'gce')
        end
      end

      context 'when the "gce" fact has no content' do
        let(:value) { {} }

        it 'resolves to nil' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'cloud.provider', value: nil)
        end
      end
    end
  end
end
