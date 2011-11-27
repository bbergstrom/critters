module ApplicationHelper
  def title(title)
    @title = title
  end

  def controller_css_class 
    return "#{params[:controller]}-#{params[:action]}"
  end

  def current_page_class(options)
    if current_page? options
      return 'current-page'
    end
    return 'not-current-page'
  end
end
