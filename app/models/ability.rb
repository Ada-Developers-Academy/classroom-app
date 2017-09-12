class Ability
  include CanCan::Ability

  def initialize(user)
    return guest_rules unless user
    unauthorized_rules unless user.authorized?

    instructor_rules if user.instructor?
    student_rules(user) if user.student?
  end

  def guest_rules
  end

  def unauthorized_rules
  end

  def instructor_rules
    alias_action :new_instructor, :new_student, to: :create
    [Cohort, Repo, Student, Submission, User, UserInvite].each do |model|
      can :manage, model
    end
  end

  def student_rules(user)
    can :read, Submission, student: { github_name: user.github_name }
  end
end
