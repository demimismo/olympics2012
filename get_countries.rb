require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://www.london2012.com/athletes/'))


countries = doc.css('select.gen-select:eq(1) option').map(&:value)