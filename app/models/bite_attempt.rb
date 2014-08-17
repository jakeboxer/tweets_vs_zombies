class BiteAttempt < ActiveRecord::Base
  enum result: [
    :success,
    :already_zombie,
    :awake,
    :not_following
  ]

  belongs_to :target, class_name: "User"
  belongs_to :biter, class_name: "User"

  def self.attempt(biter, target, client:)
    create! do |bite|
      bite.biter  = biter
      bite.target = target

      bite.result = if target.zombie?
        :already_zombie
      elsif target.awake?
        :awake
      elsif !target.following?(biter, client: client)
        :not_following
      else
        :success
      end
    end
  end

  def self.diseased_monkey_bite(user)
    create! do |bite|
      bite.biter  = user
      bite.target = user
      bite.result = :success
    end
  end

  def success?
    result == :success
  end

  def failure?
    !success?
  end
end
