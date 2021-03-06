require 'rails_helper'

RSpec.describe SubServiceRequest, type: :model do

  describe ".formatted_status" do

    before { SubServiceRequest.skip_callback(:save, :after, :update_org_tree) }
    after { SubServiceRequest.set_callback(:save, :after, :update_org_tree) }
      
    context "constants.yml mapping present" do

      it "should return the value from constants.yml" do
        sub_service_request = create(:sub_service_request, status: "get_a_cost_estimate")

        expect(sub_service_request.formatted_status).to eq("Get a Cost Estimate")
      end
    end

    context "constants.yml mapping not present" do

      it "should return a default status" do
        sub_service_request = create(:sub_service_request, status: "bad_status")

        expect(sub_service_request.formatted_status).to eq("STATUS MAPPING NOT PRESENT")
      end
    end
  end
end
