module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Textr"
    end
  end
end
