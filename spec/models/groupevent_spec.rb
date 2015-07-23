require 'rails_helper'

RSpec.describe Groupevent, type: :model do
  context 'empty params' do
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array([-1, 0, 1]) }
    it { should_not validate_presence_of(:name) }
  end

  context 'draft event' do
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array([-1, 0, 1]) }
    it { should_not validate_presence_of(:name) }
  end

  context 'publish invalid event' do
    event = Groupevent.create(status: 1)
    event.valid?
    it { expect(event).to be_invalid }
  end

  context 'publish invalid event status' do
    event = Groupevent.create(status: 2,startdate: '01/01/2015', enddate: '30/01/2015', name: 'test', description: 'test', location: 'Paris')
    event.valid?
    it { expect(event).to be_invalid }
  end

  context 'publish valid event' do
    event = Groupevent.create(status: 1,startdate: '01/01/2015', enddate: '30/01/2015', name: 'test', description: 'test', location: 'Paris')
    event.valid?
    it { expect(event).to be_valid }
  end

end
