require 'rails_helper'

RSpec.describe Hyrax::ImageForm do
  it { expect(described_class).to be < Hyrax::Forms::WorkForm }

  describe '#build_permitted_params' do
    subject { described_class.build_permitted_params }

    context 'permitted params' do
      it do
        expect(described_class).to receive(:permitted_date_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_identifier_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_person_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_rights_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_version_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_relation_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_custom_property_params).at_least(:once).and_call_original
        subject
      end
    end
  end

end
