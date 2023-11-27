# frozen_string_literal: true

require 'rails_helper'

require 'google/apis/civicinfo_v2'

describe Representative do
  describe '.civic_api_to_representative_params' do
    let(:offices) do
      instance_double(
        Google::Apis::CivicinfoV2::Office,
        name: 'Office1',
        division_id: 'Division1', official_indices: [0]
      )
    end
    let(:officials) do
      instance_double(Google::Apis::CivicinfoV2::Official,
                      name:      'Gavin Newsom',
                      address:   nil,
                      party:     'Democrat',
                      photo_url: '')
    end

    let(:rep_info) do
      instance_double(
        Google::Apis::CivicinfoV2::RepresentativeInfoResponse,
        officials: [officials],
        offices:   [offices]
      )
    end

    let(:non_nil_addr) do
      [instance_double(Google::Apis::CivicinfoV2::SimpleAddressType,
                       line1: '123 Fake St',
                       city:  'Berkeley',
                       state: 'CA',
                       zip:   94_709)]
    end

    it 'Representative already exists' do
      expect(described_class.count).to eq(0)
      # Insert the same representative twice
      described_class.civic_api_to_representative_params(rep_info)
      reps = described_class.civic_api_to_representative_params(rep_info)
      expect(reps.count).to eq(described_class.count)
    end

    it 'Parses non-nil address correctly' do
      addr = described_class.parse_address(non_nil_addr)
      expect(addr).to eq('123 Fake St Berkeley CA 94709')
    end

    it 'Parses nil address correctly' do
      addr = described_class.parse_address([])
      expect(addr).to eq('')
    end
  end
end
