class Ability
  include CanCan::Ability

  def initialize(user)
    instructor_rules if user.instructor?
  end

  def instructor_rules
    can :read, Cohort
    can :read, Repo
    can :read, Student
    can :read, Submission
    can :read, User
    can :read, UserInvite
  end
end
