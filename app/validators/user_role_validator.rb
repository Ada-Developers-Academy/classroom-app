class UserRoleValidator < ActiveModel::Validator
  def validate(record, role_attr=:role)
    if !record.respond_to?(role_attr.to_sym)
      raise ArgumentError.new("Record must have a '#{role_attr}' attribute.")
    end

    if !User::ROLES.include? record.send(role_attr)
      msg = "must be one of #{User::ROLES.to_sentence(
                                two_words_connector: ' or ',
                                last_word_connector: ', or '
                              )}"
      record.errors[role_attr] << msg
    end
  end
end
