require 'singleton'
class NetTransceiver
  include Singleton
  PRICE_URL = 'http://p.3.cn/prices/mgets?type=1&skuIds='
  class << self

    def set_cookies_info
      url = "https://mercury.jd.com"
      host = URI(url).host
      Typhoeus::Request.get url, headers: header_hash.merge({'Host':host}), cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true
      url = "https://mercury.jd.com/log.gif?t=www.100000"
      host = URI(url).host
      Typhoeus::Request.get url, headers: header_hash.merge({'Host':host, 'Referer': 'https://www.jd.com/'}), cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true
      Typhoeus::Request.get url, headers: header_hash.merge({'Host':host, 'Referer': 'https://www.jd.hk/'}), cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true
    end

    #   单次请求
    def single_get url
      url = url.match(/^http/) ? url : 'http://'+url
      host = URI(url).host
      Typhoeus::Request.get url, headers: header_hash.merge({'Host':host}), cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true
      # yield if block_given?
    end

    def multi_get hash
      Typhoeus::Config.cache = Typhoeus::Cache::Rails.new
      hydra = Typhoeus::Hydra.new(max_concurrency: 3)
      options = {headers: header_hash, cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true}
      hash.each do |k, s_hash|
        url = s_hash[:link]
        request = Typhoeus::Request.new(url, options)
        yield(k, request) if block_given?
        hydra.queue(request)
      end
      hydra.run
      hash
    end


    def get_price id
      rep = request_price(id).body.sub(/JQuery\d+\(/, '').gsub(/[)|\n|\;]/,'')
      (JSON.parse(rep).first || {})['p']
    end

    def request_price id, options = {}
      id = "J_#{id}"
      callback_timestamp = "&callback=JQuery#{rand(1000000)}&_=#{(Time.now.to_f*100).to_i}&area=1&origin=2&source=jd_worldwide"
      host = URI(PRICE_URL).host
      Typhoeus::Request.get(PRICE_URL+id + callback_timestamp, headers: header_hash.merge({'Host':host, 'Referer': 'http://www.jd.hk/'}), cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true)
    end

    def multi_price_get ids
      Typhoeus::Config.cache = Typhoeus::Cache::Rails.new
      hydra = Typhoeus::Hydra.new(max_concurrency: 3)
      options = {headers: header_hash, cookiefile: cookie_file_path, cookiejar: cookie_file_path, followlocation: true}
      hash = {}
      ids.each do |id|
        request = request_price id, options
        yield(hash, request) if block_given?
        # request.on_complete do |response|
        #   if response.success?
        #     hash[id] = JSON.parse(response.body)['p']
        #   end
        # end
        hydra.queue request
      end
      hash
    end

    def header_hash options={}
      {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36',
          'Accept-Language': 'zh-CN,zh;q=0.8,en;q=0.6',
          'Connection': 'keep-alive',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Upgrade-Insecure-Requests': 1
      }
    end

    def cookie_file_path
      "public/cookie_jar"
    end
  end
end
