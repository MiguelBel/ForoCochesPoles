class FCURL
  class << self; attr_accessor :thread_url end

  @thread_url = "http://www.forocoches.com/foro/showthread.php?t="

  def self.buildThreadURL(id)
    return "#{@thread_url}#{id}"
  end

  def self.buildThreadURLWithPage(id, page)
    return "#{self.buildThreadURL(id)}&page=#{page}"
  end

  def self.retrieveIDFromURL(url)
    return url.gsub(@thread_url, "").to_i
  end
end