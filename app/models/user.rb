class User < ApplicationRecord
  validates :name, :uid, :provider, :github_name, presence: true
  validates_with UserRoleValidator

  ROLES = %w( instructor student unknown )

  def self.update_or_create_from_omniauth(auth_hash)
    gh_info = github_info(auth_hash)
    puts gh_info.inspect
    user = self.find_by(uid: gh_info[:uid], provider: gh_info[:provider])
    puts user.inspect
    if !user.nil?
      return user if user.update(gh_info)
    else
      # no user found, do something here
      user = User.new(gh_info)

      if user.save
        return user
      else
        return nil
      end
    end
  end

  def accept_invite(invite)
    raise ArgumentError.new("Invite is not valid") unless invite.valid?
    raise ArgumentError.new("Invite already used") if invite.accepted?

    transaction do
      update!(role: invite.role)
      invite.update!(accepted: true)
    end
  end

  def instructor?
    role == 'instructor'
  end

  def student?
    role == 'student'
  end

  def authorized?
    role != 'unknown'
  end

  private

  def self.github_info(auth_hash)
    {
      uid: auth_hash["uid"],
      provider: auth_hash["provider"],
      github_name: auth_hash["extra"]["raw_info"]["login"],
      name: auth_hash["info"]["name"] || auth_hash["extra"]["raw_info"]["login"]
    }
  end
end
