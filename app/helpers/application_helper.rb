module ApplicationHelper
  def title(title)
    @title = title
  end

  def controller_css_class 
    return "#{params[:controller]}-#{params[:action]}"
  end
end
