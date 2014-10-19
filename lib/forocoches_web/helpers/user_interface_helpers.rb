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

end