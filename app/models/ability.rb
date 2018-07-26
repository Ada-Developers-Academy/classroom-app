class Ability
  # self.abstract_class = true
include CanCan::Ability

  def initialize(user)
    puts "11111111"
    return guest_rules unless user
    unauthorized_rules unless user.authorized?
    puts "2222222222"
    instructor_rules if user.instructor?
    puts "333333333333"
    student_rules(user) if user.student?
  end

  def guest_rules
  end

  def unauthorized_rules
  end

  def instructor_rules
    alias_action :new_instructor, :new_student, to: :create
    [Classroom, Assignment, Student, Submission, User, UserInvite, Instructor, Cohort].each do |model|
      can :manage, model
    end
    # can :manage, @submission.students.build
  end

  def student_rules(user)
    can :read, Submission, student: { github_name: user.github_name }
    can :read, Student, github_name: user.github_name
  end

end
