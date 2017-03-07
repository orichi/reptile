require 'singleton'
class NokoFilter
  class << self
    def filter_html html, *css
      dom = Nokogiri::HTML(html)
      filter(dom, *css)
    end

    def filter dom, *css
      css.map do |sub_css|
        # debugger
        dom = dom.css(sub_css)
      end
      dom
    end


  end
end