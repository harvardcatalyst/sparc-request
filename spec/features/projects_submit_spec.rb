require 'spec_helper'

describe "creating a new project " do 
  let_there_be_lane
  fake_login_for_each_test
  build_service_request_with_project()

  before :each do
    visit protocol_service_request_path service_request.id

    click_link "New Project"
    wait_for_javascript_to_finish

    find(:xpath, "//input[@alt='SaveAndContinue']").click
    wait_for_javascript_to_finish
  end

  after :each do
    wait_for_javascript_to_finish
  end

  describe "submitting a blank form" do
    it "should show errors when submitting a blank form", :js => true do
      find('#errorExplanation').visible?().should eq(true)
    end

    it "should require a protocol title", :js => true do
      page.should have_content("Title can't be blank")
    end
  end

  describe "submitting a filled form", :js => true do

    it "should clear errors and submit the form" do
      fill_in "project_short_title", :with => "Bob"
      fill_in "project_title", :with => "Dole"
      select "Federal", :from => "project_funding_source"
      select "PD/PI", :from => "project_role_role"
      click_button "Add Authorized User"
      wait_for_javascript_to_finish

      find(:xpath, "//input[@alt='SaveAndContinue']").click

      find("#service_request_protocol_id").value().should eq Protocol.last.id.to_s
    end
  end
end

describe "editing a project" do
  let_there_be_lane
  fake_login_for_each_test
  build_service_request()
  build_project()

  before :each do
    visit protocol_service_request_path service_request.id
  end

  describe "editing the short title", :js => true do

    it "should save the short title" do
      click_button("Edit Project")
      fill_in "project_short_title", :with => "Bob"
      find(:xpath, "//input[@alt='SaveAndContinue']").click
      click_button("Edit Project")

      find("#project_short_title").value().should eq("Bob")
    end
  end

end
