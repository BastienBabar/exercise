require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    @event_json = {groupevent: {status: 0,startdate: '2015-01-01', enddate: '2015-01-30',
                                  name: 'event',description: 'event', location: 'Paris'}}
    @event_json_update = {groupevent: {status: 1,startdate: '2015-01-01', enddate: '2015-01-30',
                                       name: 'event', description: 'better event', location: 'Paris'}}
    @event_result_json = {startdate: '2015-01-01', enddate: '2015-01-30',
                                       name: 'event', description: 'event', location: 'Paris', status: 0}
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


  end
end
