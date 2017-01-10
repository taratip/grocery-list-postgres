require "spec_helper"

feature "user update grocery item" do
  scenario "see name of grocery on grocery item show page" do
    db_connection do |conn|
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = ["eggs"]
      conn.exec_params(sql_query, data)
    end

    visit "/groceries"
    click_link "Update"

    expect(page).to have_selector("input[value='eggs']")
  end

  scenario "successfully update name of the item" do
    db_connection do |conn|
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = ["eggs"]
      conn.exec_params(sql_query, data)
    end

    visit "/groceries"
    click_link "Update"

    fill_in "Name", with: "White egg"
    click_button "Update"

    expect(page).to have_content "White egg"
  end

  scenario "submit the update form without name" do
    db_connection do |conn|
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = ["eggs"]
      conn.exec_params(sql_query, data)
    end

    visit "/groceries"
    click_link "Update"

    fill_in "Name", with: ""
    click_button "Update"
  
    expect(page).to have_selector("input[value='eggs']")
  end
end
