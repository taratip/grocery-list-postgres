require "spec_helper"

feature "user delete grocery item" do
  scenario "successfully delete grocery item" do
    db_connection do |conn|
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = ["eggs"]
      conn.exec_params(sql_query, data)
    end

    visit "/groceries"
    click_button "Delete"

    expect(page).to_not have_content "eggs"
  end
end
