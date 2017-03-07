class ReptilesController < ApplicationController
  def index
    NetTransceiver.single_get 'http://passport.jd.com/new/helloService.ashx?callback=jQuery509791&_=1488872887957'
    @data = CatRecord.all
  end

  def show
    # url = #session[:info][params[:id]] TODO DB获取存储的链接信息

    cat_record = CatRecord.find(params[:id])
    cat_record.product_load
    @hash = ProdRecord.where(cat_record: cat_record).paginate :page => params[:page], :per_page => 20
  end
end
