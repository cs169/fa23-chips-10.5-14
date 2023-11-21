# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

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

      # rep = Representative.create!({ name: official.name, ocdid: ocdid_temp,
      #    title: title_temp })
      # reps.push(rep)

      # Check if a representative with the same name already exists
      existing_representative = Representative.find_by(name: official.name)
      if existing_representative
        # Handle the case where a representative with the same name exists
        # You might want to update attributes or log a message here
        puts "Representative with name '#{official.name}' already exists."
      else
        # Create a new representative if it doesn't already exist
        rep = Representative.create!({ name: official.name, ocdid: ocdid_temp, title: title_temp })
        reps.push(rep)
      end
    end

    reps
  end
end