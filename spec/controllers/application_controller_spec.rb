require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    @event_json = {groupevent: {status: 0,startdate: '2015-01-01', enddate: '2015-01-30',
                                name: 'event',description: 'event', location: 'Paris'}}
    @event_json_update = {groupevent: {status: 1,startdate: '2015-01-01', enddate: '2015-01-30',
                                       name: 'event', description: 'better event', location: 'Paris'}}
    @event_result_json = {startdate: '2015-01-01', enddate: '2015-01-30',
                          name: 'event', description: 'event', location: 'Paris', status: 0}
    @event_bad_json = {startdate: '2015-01-01', enddate: '2015-01-30',
                       name: 'event', description: 'event', location: 'Paris', status: 0}
    @event_json_desc_missing = {groupevent: {status: 2,startdate: '2015-01-01', enddate: '2015-01-30',
                                             name: 'event', location: 'Paris'}}
  end

  describe "actions" do
    describe "#create" do
      before do
        @request.env['RAW_POST_DATA'] = @event_json.to_json
        lambda do
          post :create
        end.should change(Groupevent, :count).by(1)
      end

      it "returns ok" do
        expect(response.status).to eq(200)
        expect(Groupevent.all.last.name).to eq(@event_json[:groupevent][:name])
        response.body.should == @event_result_json.to_json
      end

      describe "#update" do
        before do
          @request.env['RAW_POST_DATA'] = @event_json_update.to_json
          lambda do
            put :update
          end.should change(Groupevent, :count).by(0)
        end

        it "returns ok" do
          expect(response.status).to eq(200)
          expect(Groupevent.find_by_name(@event_json_update[:groupevent][:name]).description).to eq(@event_json_update[:groupevent][:description])
        end
      end

      describe "#destroy" do
        before do
          @request.env['RAW_POST_DATA'] = @event_json_update.to_json
          lambda do
            put :destroy
          end.should change(Groupevent, :count).by(0)
        end

        it "returns ok" do
          expect(response.status).to eq(200)
          expect(Groupevent.find_by_name(@event_json_update[:groupevent][:name]).status).to eq(-1)
        end
      end

      context "create same event" do
        before do
          @request.env['RAW_POST_DATA'] = @event_json.to_json
          post :create
        end

        it "returns 409" do
          expect(response.status).to eq(409)
        end
      end
    end

    describe "#show" do
      before do
        @request.env['RAW_POST_DATA'] = @event_json.to_json
        lambda do
          post :create
        end.should change(Groupevent, :count).by(1)
        get :show
      end

      it "returns ok" do
        expect(response.status).to eq(200)
        response.body.should == @event_result_json.to_json
      end
    end

    context 'bad requests' do
      describe "#create" do
        before do
          @request.env['RAW_POST_DATA'] = @event_bad_json.to_json
          post :create
        end

        it 'returns 400' do
          expect(response.status).to eq(400)
        end
      end

      describe "missing field in json returns 400" do
        context 'create' do
          before do
            @request.env['RAW_POST_DATA'] = @event_json_desc_missing.to_json
            post :create
          end

          it 'returns 400' do
            expect(response.status).to eq(400)
          end
        end
      end

      describe "#update" do
        before do
          @request.env['RAW_POST_DATA'] = @event_bad_json.to_json
          put :update
        end

        it 'returns 400' do
          expect(response.status).to eq(400)
        end
      end
    end
  end
end
