require 'nokogiri'
require 'open-uri'
require 'pry'

uri = "https://www.gismeteo.ua/weather-kyiv-4944/month/"
@doc = Nokogiri::HTML(open(uri))

@f = File.open('weather.txt','w')

def extract_string_from_node(param,css_class)
  param.search(css_class).text
end

def form_day_temperature(day,month)
  day_title = extract_string_from_node(day,'.link-day .day')
  max_temp = extract_string_from_node(day,'.link-day .temp.max .m_temp.c')
  min_temp = extract_string_from_node(day,'.link-day .temp.min .m_temp.c')
  @f.write("#{day_title} #{month} , min #{min_temp} C, max #{max_temp} C \n")
end

def day_node_from_nokogiri_by_tag(day,month)
  day_of_the_week = day.search('td')
  day_of_the_week.each do |item|
    if item.search('.link-day .day').text.length > 0
      form_day_temperature(item,month)
    end
  end
end

def weeks_node_from_nokogiri_by_tag(row,month)
  weeks = row.search('tr')
  weeks.each do |day|
    day_node_from_nokogiri_by_tag(day,month)
  end
end



def extract_month_title_from_string(title)
  /[а-я]+/.match(title.downcase)
end

def month_node_from_nokogiri_by_class
  month_titles = @doc.search('.fcontent h3')
  month_titles.each do |month|
    month_title = extract_month_title_from_string(month.content)
    table_node_from_nokogiri_by_class(month_title)
  end
end










 month_node_from_nokogiri_by_class

@f.close

