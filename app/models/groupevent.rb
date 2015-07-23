class Groupevent < ActiveRecord::Base

  validates :startdate, :enddate, :name, :description, :location, presence: :true, if: :status_is_publish?
  validates :status, inclusion: { in: %w(-1 0 1) }, presence: :true
#numericality: { only_integer: true, less_than_or_equal_to: 1, greater_than_or_equal_to: -1 },
  private
  def status_is_publish
    status == 1
  end
end
