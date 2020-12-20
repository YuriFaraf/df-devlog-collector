require 'nokogiri'
require 'open-uri'

devlogs = []

years = %w[2018] # от 18 всего один пост остался, но зато скоро 20 повезут

years.each do |year|
  if not File.exist?("#{__dir__}/data/#{year}.html")
    puts "Читаю #{year}."
    doc = Nokogiri::HTML(open("http://www.bay12games.com/dwarves/dev_#{year}.html"))
    puts "Сохраняю #{year}."
    File.write("#{__dir__}/data/#{year}.html", doc)
    if not year == years.last
      puts "Перекур 5 сек."
      sleep(5) # не дудось Жабу
    end
  else
    puts "#{year} уже сохранён."
  end

  doc = Nokogiri::HTML(File.read("#{__dir__}/data/#{year}.html"))

  # first стоит для пробы и для 2018 года
  devlogs << doc.css('.dev_progress').first
end

devlogs.each do |devlog|
  date_im = devlog.css('.date').to_s.gsub(/<[^>]*>/, '')
  mm, dd, yy = date_im.split('/')
  date = "#{dd}.#{mm}.#{yy}"
  months_ru = %w[января февраля марта апреля мая июня
    июля августа сентября октября ноября декабря]
  date_ru = "#{dd} #{months_ru[mm.to_i-1]} #{yy} года"

  doc = "Новости разработки:\n\n"
  doc += "🇷🇺 #{date_ru}\n\n🇬🇧 "
  # TODO: до первого гсаба нужно спасти картинки и ссылки из текста
  doc += devlog.to_s.
    gsub(/<[^>]*>/, '').
    gsub(/[ ]{2,}/, ' ').
    gsub(/(\r\n|\r|\n)+/, "\n").strip
  doc += "\n\n#Development_Log@dwarf.fortress #DF #DwarfFortress"

  File.write("#{__dir__}/result/#{date}.txt", doc)
end
