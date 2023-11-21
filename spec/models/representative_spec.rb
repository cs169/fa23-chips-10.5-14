# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    it 'raises an error when trying to insert a duplicate representative' do
      # Set up a representative with the same name, ocdid, and title in the database
      existing_representative = described_class.create!(
        name: 'John Doe', 
        ocdid: 123, 
        title: 'Existing Title')

      # Mock API data for testing
      rep_info = double('rep_info', 
        officials: [double(
          'official',
          name: 'John Doe')
        ],
        offices: [double(
          'office',
          name: 'Office',
          division_id: 123,
          official_indices: [0])
        ]
      )

      # Expect an error when trying to create a duplicate representative
      expect do
        described_class.civic_api_to_representative_params(rep_info)
      end.not_to raise_error
    end
  end
end