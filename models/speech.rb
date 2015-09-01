class Speech < ActiveRecord::Base
  validates :title, presence: true
  validates :user_id, presence: true, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }
  validates :expected_duration, presence: true, :numericality => { :greater_than_or_equal_to => 0, :only_integer => true }
  # new: newly created, draft.
  # auditing: speaker submits and waits for auditing.
  # approved: admin approves and arranges time for it
  # confirmed: speaker agrees the arrangement
  # finish: the speech is finished.
  # closed: close by the speaker or admin
  validates :status, presence: true, inclusion: {in: [Constants::NEW, Constants::AUDITING, Constants::APPROVED, Constants::CONFIRMED, Constants::FINISHED, Constants::CLOSED], message: "%{value} is not a valid role"}
  validates :category, presence: true, inclusion: {in: [Constants::WEEKLY, Constants::MONTHLY], message: "%{value} is not a valid role"}

  belongs_to :speaker, :class_name => :User, :foreign_key => "user_id"

  has_many :audience_registrations
  # users who have applied as audiences
  has_many :audiences, :through => :audience_registrations, :source => :user

  has_many :attendances
  # users who really attended this speech, including as audiences and speakers
  has_many :participants, :through => :attendances, :source => :user
end