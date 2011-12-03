class CritterLimitValidator < ActiveModel::Validator
  def validate(record)
    if !record.user.nil? && record.user.critters.count > 20
      record.errors[:base] << "You have reached the max number(20) of critters!"
    end
  end
end

