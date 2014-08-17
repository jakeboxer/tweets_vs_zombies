class BiteAttempt < ActiveRecord::Base
  enum result: [
    :success,
    :was_already_zombie,
    :was_awake,
    :was_not_following_biter
  ]

  belongs_to :target, class_name: "User"
  belongs_to :biter, class_name: "User"

  def self.attempt(biter, target, client:)
    create! do |bite|
      bite.biter  = biter
      bite.target = target

      bite.result = if target.zombie?
        :was_already_zombie
      elsif target.awake?
        :was_awake
      elsif !target.following?(biter, client: client)
        :was_not_following_biter
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

  def failure?
    !success?
  end
end
