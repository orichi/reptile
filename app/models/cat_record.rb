class CatRecord < ApplicationRecord
  has_many :prod_records

  def self.insert_all(link_hash, count_hash)
    link_hash.each do |k,value|
      next if where(name: k).count > 0
      self.find_or_create_by({
          name: k,
          link: value[:link],
          count: count_hash[k][0],
          paginate_link: count_hash[k][2],
          pages_count: count_hash[k][1]
                  })
    end
  end

  def product_load

    url = self.try(:link)
    total_page = self.pages_count == 0 ? 1 : self.pages_count
    1.upto(total_page) do |page|
      url = url.sub(/page=\d+/, "page=#{page}")
      request = NetTransceiver.single_get url
      items = Dissect::Category.get_items request.body
      items.each{|x| Dissect::Product.get_info(x, {link: url, page: page, cat_record_id: self.id})}
    end

  end
end
