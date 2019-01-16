require 'nokogiri'
require 'open-uri'
require 'pry'

uri = "https://www.gismeteo.ua/weather-kyiv-4944/month/"
doc = Nokogiri::HTML(open(uri))

@f = File.open('weather.txt','w')

@month_titles = doc.search('.fcontent h3')
@weather_rows = doc.search('.fcontent table.calendar')

def filter_month_title(title)
  /[а-я]+/.match(title.downcase)
end

def generate_month
  @month_titles.each do |month|
    month_title = filter_month_title(month.content)
    generate_rows(month_title)
  end
end

def generate_rows(month)
  @weather_rows.each do |row|
    generate_weeks(row,month)
  end
end

def generate_weeks(row,month)
  weeks = row.search('tr')
  weeks.each do |day|
    generate_day(day,month)
  end
end

def generate_day(day,month)
  day_of_the_week = day.search('td')
  day_of_the_week.each do |item|
    if item.search('.link-day .day').text.length > 0
      form_day_temperature(item,month)
    end
  end
end

def handle_string(param,css_class)
  param.search(css_class).text
end

def form_day_temperature(day,month)
  day_title = handle_string(day,'.link-day .day')
  max_temp = handle_string(day,'.link-day .temp.max .m_temp.c')
  min_temp = handle_string(day,'.link-day .temp.min .m_temp.c')
  @f.write("#{day_title} #{month} , min #{min_temp} C, max #{max_temp} C \n")
end

generate_month

@f.close

