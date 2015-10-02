require 'rails_helper'

RSpec.describe Portal::ProtocolsController do
	stub_portal_controller

	let!(:identity) { create(:identity)}

	before :each do
    session[:identity_id] = identity.id
  end

	describe "GET #index.js" do
		let!(:archived_protocol) { create(:protocol_without_validations, archived: true) }
		let!(:unarchived_protocol) { create(:protocol_without_validations, archived: false) }
		let!(:project_role_one) { create(:project_role, protocol: unarchived_protocol, identity: identity, project_rights: "not none")}
		let!(:project_role_two) { create(:project_role, protocol: archived_protocol, identity: identity, project_rights: "not none")}
		before {get :index, format: :js}
		it "it does not contain archived protocol" do
    	expect(assigns(:protocols)).to eq([unarchived_protocol]) 
   	end
	
	end
end