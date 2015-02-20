# -*- coding: utf-8 -*-
## Scraper for Mouser Pages
#
# Yay have to scrape this data >:-(
#

require 'nokogiri'
require 'open-uri'

def scrape_mouser (order_code)

  if not /^\d{3}\-/.match(order_code)
    return nil
  end

  item = Hash.new
  item[:order_code] = order_code
  item[:page] = "http://uk.mouser.com/Search/Refine.aspx?N=1323043&Keyword="+order_code

  @fn_page = Nokogiri::HTML(open(item[:page]))

  # Title. Read Part name and description
  title = @fn_page.at_xpath("//title").inner_html
  item[:title] = title
  #item[:partname], *rest = title.split(" - ", 2)
  #item[:desc] = title.join.split(" | ")

  # Partname and Description
  item[:partname] = @fn_page.css("div #divManufacturerPartNum h1").inner_html.strip
  item[:desc] = @fn_page.css("div #divDes").inner_html.strip

  # Stock
  # stocks = Hash.new
  # stock_numbers = @fn_page.css("div #priceWrap ul li strong")
  # stock_locations = @fn_page.css("div #priceWrap ul li")

  # for i in 0...(stock_numbers.count)

  #   number = stock_numbers[i].inner_html
  #   location = stock_locations[i].inner_html[/\(.*stock\)/]

  #   stocks[location] = number
  # end
  # item[:stocks] = stocks

  # Pricing
  # prices = Hash.new
  # price_breaks = @fn_page.xpath("//table[@class='pricing ']/tbody/tr/td[@class='qty']")
  # price_prices = @fn_page.xpath("//table[@class='pricing ']/tbody/tr/td[@class='threeColTd']")

  # for i in 0...(price_breaks.count)

  #   min = price_breaks[i].inner_html[/(\d+)(.*-|\+)/, 1].to_i
  #   max = price_breaks[i].inner_html[/-.+?(\d+)/, 1].to_i
  #   max = nil if max == 0
  #   price = price_prices[i].inner_html[/£\d+\.\d+/]

  #   prices[{:min => min, :max => max}] = price
  # end
  # item[:prices] = prices

  # Order quantities
  # common_info = @fn_page.css("div #priceWrap div #commonInfo p").to_s
  # item[:order_unit] = common_info[/<strong>Price for:<\/strong>\s*([^\t\r\n\f]*)\s*<\/p>/, 1]
  # item[:moq] = common_info[/<strong>Minimum order quantity:<\/strong>\s*(\d*)\s*<\/p>/, 1].to_i
  # item[:multiple] = common_info[/<strong>Minimum order quantity:<\/strong>\s*(\d*)\s*<\/p>/, 1].to_i

  return item
end
