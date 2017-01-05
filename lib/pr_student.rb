class PRStudent
  attr_accessor :github, :pr_created, :pr_url, :student_model

  def initialize(*args)
    @student_model = args.first
    if args.length > 1
      @github = args[1]
      @pr_created = args[2]
      @pr_url = args[3]
    end
  end
end
