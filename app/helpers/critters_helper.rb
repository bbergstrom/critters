module CrittersHelper

  def has_disability(ability_boolean)
    if !ability_boolean
      return content_tag(:span, '<--Disability', :class => "disability")
    end
  end

end
