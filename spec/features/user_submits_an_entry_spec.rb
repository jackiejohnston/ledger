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
    select "Sofi", from: "payee"
    select "loan", from: "category"
    fill_in "amount", with: "-695.00"
    click_on "Add"

    expect(page).to have_text "Sofi"
  end

  scenario "they can delete transaction" do
    visit root_path
    fill_in "posted_on", with: Date.today
    select "Sofi", from: "payee"
    select "loan", from: "category"
    fill_in "amount", with: "-695.00"
    click_on "Add"
    click_on "Delete"

    expect(page).not_to have_text "$-695.00"
  end

  # scenario "they can edit transaction" do
  #   Transaction.create(posted_on: Date.today, payee: "Sofi", category: "loan",
  #                      amount: -695)
  #   visit root_path
  #   click_on "Edit"
  #   fill_in "amount", with: "-795"
  #   click_on "Update"

  #   expect(page).to have_text "$-795.00"
  # end
end