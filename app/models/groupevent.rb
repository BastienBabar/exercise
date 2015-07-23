class Groupevent < ActiveRecord::Base
  #attr_accessor :status #, :startdate, :enddate, :name, :description, :location

  validates :status, inclusion: { in: [-1, 0, 1] }, presence: :true
  validates_presence_of :startdate, :enddate, :name, :description, :location, :if => lambda {|s| s.status == 1 }
end
