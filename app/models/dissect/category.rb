module Dissect #  刨析nokogiri（html)
  class Category #  解析分类
    class << self
      def get html
        hash = {}
        NokoFilter.filter_html(html, 'div[class="item"]').each do |dom|
          prefix = dom.css('h3').css('a').text + '_'
          dom.css('h4').each do |dom_item|
            hash[prefix+dom_item.css('a').text] = {link: dom_item.css('a').attribute('href').value.sub(/^\/\//, '')}
          end
        end
        hash
      end

      def get_count hash
        NetTransceiver.multi_get(hash) do |k, request|
          request.on_complete do |response|
            if response.success?
              tmp = NokoFilter.filter_html(response.body, 'div[class="s-title"]').text
              count = (tmp && tmp.match(/\d+/)) ? tmp.match(/(\d+)/)[1] : 0
              page_link_dom = NokoFilter.filter_html(response.body, 'a[class="curr"]')
              page_link  =   page_link_dom.present? ? page_link_dom.attribute('href').value.sub(/^\/\//, '') : ''
              total_page_dom = NokoFilter.filter_html(response.body, 'span[class="p-skip"]')
              total_page = total_page_dom.present? ? total_page_dom.text.match(/(\d{1,})/) : 0
              hash[k] = [count, (total_page ? total_page[1] : 1) , page_link]
            else
              hash[k] = [0, 0, '']
            end
          end
        end
      end

      def get_items html
        NokoFilter.filter_html html, 'li[class="gl-item"]'
      end


    end

  end
end
