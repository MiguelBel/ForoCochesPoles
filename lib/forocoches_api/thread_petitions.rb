class FCThread
  attr_reader :id_thread

  def initialize(id, petition_response = false)
    @id_thread = id
    @thread_url = FCURL.buildThreadURL(id)
    
    if petition_response == false
      @petition = Curl::Easy.new
      @petition.timeout = 30
      @petition.follow_location = true
      @petition.url = @thread_url
      @petition.perform
      @content = @petition.body_str
    end

    @content = petition_response if petition_response

    @thread_nokogiri_parsed = Nokogiri::HTML(self.content)
  end

  def default_url
    return @thread_url
  end

  def content
    return @content
  end

  def status
    return self.getStatusOfThread
  end

  def getStatusOfThread
    # There are 4 status of thread:
    # 1.- Everything ok
    # 2.- Never created thread
    # 3.- Censured thread (+prv, +hd, +18...)
    # 4.- Deleted thread ("Tema especificado invalido")

    return 4 if self.isDeletedThread?
    return 3 if self.isCensoredThread?
    return 2 if self.hasNeverBeenCreated?
    return 1
  end

  def hasNeverBeenCreated?
    panel_content = ""

    @thread_nokogiri_parsed.search("div.panel div div").each do |panel_information|
      panel_content = panel_information.text
    end

    return panel_content == "Ningún Tema especificado."
  end

  def isCensoredThread?
    panel_content = ""

    @thread_nokogiri_parsed.search("div.panel div div strong").each do |panel_information|
      panel_content = panel_information.text
    end

    return panel_content == "Tema no disponible"
  end

  def isDeletedThread?
    panel_content = ""

    @thread_nokogiri_parsed.search("div.panel div div center").each do |panel_information|
      panel_content = panel_information.text
    end

    return panel_content == "Tema especificado inválido."
  end

  def listOfPosters
    @list_of_posters = []

    @thread_nokogiri_parsed.search('tr[@valign="top"]').each do |posts_informations|
      posts_informations.search('a.bigusername').each do |poster|
        @list_of_posters.push(poster.text)
      end
    end

    return @list_of_posters
  end

  def listOfTimeOfPosters
    @list_of_time = []

    @thread_nokogiri_parsed.search('table.tborder td.thead').each_with_index do |time_information, index|
      if index == 0 || index % 2 == 0
        time = time_information.text
        @list_of_time.push(time)
      end
    end

    return @list_of_time
  end

  def poleman
    list_of_posters = listOfPosters
    return false if getStatusOfThread != 1 || list_of_posters.count == 0
    return nil if list_of_posters.count < 2
    return list_of_posters[1]
  end

  def pole_time
    time_of_posters = listOfTimeOfPosters
    return false if getStatusOfThread != 1 || time_of_posters.count == 0
    return nil if listOfPosters.count < 2

    return time_of_posters[1].strip
  end

  def created_time
    time_of_posters = listOfTimeOfPosters
    return false if getStatusOfThread != 1 || time_of_posters.count == 0
    return nil if listOfPosters.count < 2

    return time_of_posters[0].strip    
  end

  def category
    return false if getStatusOfThread != 1

    @thread_nokogiri_parsed.search("span.navbar a").each_with_index do |navbar_category_container, index|
      return navbar_category_container.text if index == 2
    end
  end
end