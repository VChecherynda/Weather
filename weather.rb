require 'nokogiri'
require 'open-uri'

uri = "https://www.gismeteo.ua/weather-kyiv-4944/month/"
doc = Nokogiri::HTML(open(uri))

# f = File.open('weather.txt','w')

doc.search('.month_title').each do |month|
  month_title = month.text
  weeks = month.search('tr')

  weeks.each do |day|
    day_title = day.search('.day').text

    day.each do |item|
      puts "Weather #{month_title} #{day_title}"
    end
      # min = item.search('.temp.min m_temp.c')
      # max = item.search('.temp.max m_temp.c')
  end
end

# f.close

