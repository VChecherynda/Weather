require 'nokogiri'
require 'open-uri'
require 'pry'

uri = "https://www.gismeteo.ua/weather-kyiv-4944/month/"
doc = Nokogiri::HTML(open(uri))

f = File.open('weather.txt','w')

month_titles = doc.search('.fcontent h3')
weather_rows = doc.search('.fcontent table.calendar')
  
month_titles.each do |month|
  month_title = /[А-яа-я]+/.match(month.text.downcase)

  weather_rows.each do |row, i|
    weeks = row.search('tr')

    weeks.each do |day|

      day_of_the_week = day.search('td')

      day_of_the_week.each do |item|
        if item.search('.link-day .day').text.length > 0
          day_title = item.search('.link-day .day').text
          max_temp = item.search('.link-day .temp.max .m_temp.c').text
          min_temp = item.search('.link-day .temp.min .m_temp.c').text

          f.write("#{day_title} #{month_title}, min #{min_temp} C, max #{max_temp} CC \n")

        end
      end
    end
  end
end

f.close

