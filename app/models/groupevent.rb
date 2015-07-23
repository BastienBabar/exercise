class Groupevent < ActiveRecord::Base
  validates_presence_of :name
  validates :status, inclusion: { in: [-1, 0, 1] }, presence: :true
  validates_presence_of :startdate, :enddate, :description, :location, :if => lambda {|s| s.status == 1 }
end
