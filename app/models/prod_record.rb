require 'digest'
class ProdRecord < ApplicationRecord
  belongs_to :cat_record

  def self.insert hash, options
    return true if where(version: Digest::MD5.hexdigest(hash[:desc])).count > 0
    update_info(hash, options) and return if where(j_id: hash[:j_id]).count > 0
    find_or_create_by(generate_attr_hash(hash, options))
  end

  def self.update_info hash, options
    prod  = where(j_id: hash[:j_id]).first
    prod.update_attributes(generate_attr_hash(hash, options)) if prod
  end

  def self.generate_attr_hash hash, options
    {
        j_id: hash[:j_id],
        name: hash[:name],
        price: hash[:price],
        link: hash[:link],
        spec: hash[:spec],
        desc: hash[:desc],
        version: Digest::MD5.hexdigest(hash[:desc]),
        cat_link: options[:link],
        cat_page: options[:page],
        cat_record_id: options[:cat_record_id]
    }
  end
end
