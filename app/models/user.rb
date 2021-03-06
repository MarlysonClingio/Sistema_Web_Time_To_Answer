class User < ApplicationRecord
  has_one :user_profile
  accepts_nested_attributes_for :user_profile, reject_if: :all_blank
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  after_create :set_statistic
  
  validates :firt_name, presence: true, length: { minimum: 4 }, on: :update

  def full_name
    [self.firt_name, self.last_name].join(' ')
  end

  private
  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_users])
  end
end