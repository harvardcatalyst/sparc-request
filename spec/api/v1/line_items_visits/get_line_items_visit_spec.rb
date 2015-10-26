require 'rails_helper'

RSpec.describe 'SPARCCWF::APIv1', type: :request do

  describe 'GET /v1/line_items_visit/:id.json' do

    before do
      LineItemsVisit.skip_callback(:save, :after, :set_arm_edited_flag_on_subjects)

      @line_items_visit = build(:line_items_visit)
      @line_items_visit.save validate: false
    end

    context 'response params' do

      before { cwf_sends_api_get_request_for_resource('line_items_visits', @line_items_visit.id, 'shallow') }

      context 'success' do

        it 'should respond with an HTTP status code of: 200' do
          expect(response.status).to eq(200)
        end

        it 'should respond with content-type: application/json' do
          expect(response.content_type).to eq('application/json')
        end

        it 'should respond with a Protocol root object' do
          expect(response.body).to include('"line_items_visit":')
        end
      end
    end

    context 'request for :shallow record' do

      before { cwf_sends_api_get_request_for_resource('line_items_visits', @line_items_visit.id, 'shallow') }

      it 'should respond with a single shallow line_items_visit' do
        expect(response.body).to eq("{\"line_items_visit\":{\"sparc_id\":#{@line_items_visit.id},\"callback_url\":\"https://127.0.0.1:5000/v1/line_items_visits/#{@line_items_visit.id}.json\"}}")
      end
    end

    context 'request for :full record' do

      before { cwf_sends_api_get_request_for_resource('line_items_visits', @line_items_visit.id, 'full') }

      it 'should respond with a Protocol' do
        parsed_body         = JSON.parse(response.body)
        expected_attributes = build(:line_items_visit).attributes.
                                keys.
                                reject { |key| ['id', 'created_at', 'updated_at', 'deleted_at'].include?(key) }.
                                push('callback_url', 'sparc_id').
                                sort

        expect(parsed_body['line_items_visit'].keys.sort).to eq(expected_attributes)
      end
    end

    context 'request for :full_with_shallow_reflections record' do

      before { cwf_sends_api_get_request_for_resource('line_items_visits', @line_items_visit.id, 'full_with_shallow_reflections') }

      it 'should respond with an array of line_items_visits and their attributes and their shallow reflections' do
        parsed_body         = JSON.parse(response.body)
        expected_attributes = build(:line_items_visit).attributes.
                                keys.
                                reject { |key| ['id', 'created_at', 'updated_at', 'deleted_at'].include?(key) }.
                                push('callback_url', 'sparc_id', 'visits', 'line_item', 'arm').
                                sort

        expect(parsed_body['line_items_visit'].keys.sort).to eq(expected_attributes)
      end
    end
  end
end
