# 京东(hk)网站产品信息抓取

#### 抓取jd全球购的分类信息，不完整的分类商品信息，对于list链接类型结构的分类产品可以全部抓取.

* Ruby版本 2.3.1

* Rails版本 5.0.2

* sqlite3

#### 使用 Nokogiri 进行页面dom资源抓取

* 详细 nokogiri 使用方法请参见[nokogiri 官网](http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html) 

* 抓取完成以后，分类及产品信息存入数据库

#### 使用 [Typhoeus](https://github.com/typhoeus/typhoeus) 进行 web 页面抓取

* Typhoeus 使用 libcurl 进行抓取，支持并发请求

* Typhoeus 对于请求的封装比较友好

### 说明
分类部分采用并发请求，线程数设置为3

每个产品信息两次次查询，页面请求一次 + 价格请求一次

该部分可以优化，分类可以按照页面进行一次并发请求，一次价格批量请求，此处未做优化

### 用法

##### 安装项目
```ruby
> cd reptile
> bundle install
.....
> rake db:create
> rake db:migrate
```

##### 抓取数据，rake 任务执行
```ruby
>rake load_data:load_cat #  获取分类信息

>rake load_data:load_prod #  获取分类产品信息
# 分类先，产品后
```

##### 启动项目
```ruby
>rails s 
```

访问首页
 ![image](https://github.com/orichi/reptile/raw/master/public/index.png)
 
点击数量链接既可看到产品信息
