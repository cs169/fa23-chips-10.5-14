Given /the following representatives exist/ do |rep_table|
    rep_table.hashes.each do |rep|
        Representative.create!(rep)
    end
end

When /I go to the first representative/ do
    first_rep = Representative.find_by(name: 'Johnny')
    visit representative_path(first_rep)
end

Then /I should see the following columns: (.*)$/ do |columns_list|
    columns_list = columns_list.split(", ")
    columns_list.each do |c|
        steps %Q{Then I should see "#{c}"}
    end
end