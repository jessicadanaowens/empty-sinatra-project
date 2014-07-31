require "active_record"

class User < ActiveRecord::Base
  has_many :photos

  attr_accessor :repeat_password

  validates :username, :presence=>true, :uniqueness=>{:message=>"is already taken"}
  validates :password, :presence=>true, :length=>{:minimum=>4, :message=>"must be at least 4 characters"}
  validate do
    if password != repeat_password
      errors.add(:password, "must match other password")
    end
  end

  def self.find_by_username(username)
    User.where(
      :username=>"#{username}"
    ).first
  end

  def self.find_by_password(username, password)
    User.where(
      :username=>"#{username}",
      :password=>"#{password}"
    ).first
  end

end