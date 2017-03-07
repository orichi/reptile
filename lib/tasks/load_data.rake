namespace :load_data do
  desc '获取分类数据'
  task load_cat: :environment do
    NetTransceiver.set_cookies_info
    request = NetTransceiver.single_get 'www.jd.hk'
    cat = Dissect::Category.get(request.body)
    count = Dissect::Category.get_count(cat.dup)
    #TODO  DB存储获取的链接、数量信息
    CatRecord.insert_all(cat, count)
  end


  desc '获取分类产品的数据'
  task load_prod: :environment do
    NetTransceiver.set_cookies_info
    CatRecord.first(2).each do |cat|
      cat.product_load
    end
  end
end
