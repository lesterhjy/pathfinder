class TripPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def initialize(user, trips)
      @user = user
      @trips = trips
    end

    def resolve
      @trips = @user.trips
    end
  end

  def index?
    true
  end

  def invite?
    true
  end

  def create?
    true
  end

  def show?
    record.users.include?(user)
  end

  def overview?
    record.users.include?(user)
  end

  def update?
    record.users.include?(user)
  end

  def send_email?
    record.users.include?(user)
  end
end
