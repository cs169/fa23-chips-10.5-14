# frozen_string_literal: true

class AddAddrToRepresentatives < ActiveRecord::Migration[5.2]
  def change
    add_column :representatives, :address, :string
  end
end
