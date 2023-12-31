# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.parse_address(addrs)
    unless addrs.nil? || addrs.length.zero?
      addr = addrs[0]
      return "#{addr.line1} #{addr.city} #{addr.state} #{addr.zip}"
    end

    ''
  end

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end

      rep = Representative.find_or_initialize_by(name: official.name)
      rep.title = title_temp
      rep.ocdid = ocdid_temp
      rep.address = parse_address(official.address)
      rep.party = official.party
      rep.photo_url = official.photo_url
      rep.save!
      reps.push(rep)
    end

    reps
  end
end
