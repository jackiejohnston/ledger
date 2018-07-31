require "rails_helper"

# As a user
# When I visit the home page
# And I fill in my payee, description (optional), debit/credit, category and amount
# And I click "Enter"
# Then I should see the transaction on the ledger

RSpec.feature "User submits an transaction" do

  scenario "they see the submitted transaction" do
    visit root_path
    fill_in "posted_on", with: Date.today
    fill_in "payee", with: "Quicken Loans"
    fill_in "category", with: "mortgage"
    fill_in "amount", with: "2495.00"
    click_on "Add"

    expect(page).to have_text "Quicken Loans"
  end
end