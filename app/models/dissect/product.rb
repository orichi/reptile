module Dissect #  刨析nokogiri（html)
  class Product
    class << self
      def get_info dom, options ={}
        name = NokoFilter.filter(dom, 'div[class="p-name"]', 'div[class="p-name"]', 'em').text.encode(Encoding::UTF_8)
        price_id = dom.inner_html.match(/data-sku\=\"(\d+)\"/)[1]
        price = NetTransceiver.get_price(price_id)
        product_link = NokoFilter.filter(dom, 'div[class="p-img"]', 'a').attribute('href').value.sub(/^\/\//, '')
        product_page = NetTransceiver.single_get(product_link).body
        product_spec = NokoFilter.filter_html(product_page, 'div#choose').text.encode(Encoding::UTF_8)
        product_desc = NokoFilter.filter_html(product_page, 'div[class="parameter-content"]').inner_html.encode(Encoding::UTF_8)
        hash = {j_id: price_id, name: name, price: price, link: product_link, spec: product_spec, desc: product_desc}

        ProdRecord.insert hash, options
      end
    end
  end
end
