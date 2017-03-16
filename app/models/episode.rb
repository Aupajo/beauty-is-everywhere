class Episode < ActiveRecord::Base
  belongs_to :series

  attr_accessor :new_series_name

  before_validation :check_new_series

  validates :name, presence: true, uniqueness: true
  validates_numericality_of :critters, less_than: 4, allow_blank: true
  validates_numericality_of :snowy_mountains, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_blank: true, message: "must be a percentage"

  validate :must_have_friends

private

  def must_have_friends
    if critters == 1
      errors.add :critters, "gotta have friends. Like I always say, everyone needs a friend."
    end

    if happy_little_trees == 1
      errors.add :happy_little_trees, "gotta have friends. Like I always say, everyone needs a friend."
    end
  end

  def check_new_series
    return unless series.nil? && new_series_name.present?

    self.series = Series.create name: new_series_name
  end
end
