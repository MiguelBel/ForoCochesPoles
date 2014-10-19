helpers do

  def thousandSeparator(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def getPolesFrom(nick)
    adapter = DataMapper.repository(:default).adapter
    select = adapter.execute("SELECT count(*) FROM poles WHERE lower(poleman) = lower(?) AND category='General'", nick)
    return select.insert_id
  end

  def globalRankingGenerator
    adapter = DataMapper.repository(:default).adapter
    out_file = File.new("lib/forocoches_web/public/global_ranking.txt", "w")
    select = adapter.select("SELECT poleman, count(*) FROM poles WHERE category='General' AND trim(poleman) IS NOT NULL and trim(poleman) != '' GROUP BY poleman ORDER BY count(*) DESC")
    select.each_with_index do |individual, index|
      out_file.puts("#{index + 1} | some #{individual.poleman} | #{individual.count} poles")
    end
    out_file.close
  end

end