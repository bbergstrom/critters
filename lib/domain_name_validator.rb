require 'public_suffix_service'

class DomainNameValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if !PublicSuffixService.valid?(value)
      object.errors[attribute] << (options[:message] || "is not a valid domain name.")
    end
  end
end

