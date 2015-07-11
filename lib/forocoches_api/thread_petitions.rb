require 'net/http'

module ForoCochesAPI
  class PetitionManager 
    attr_reader :id_thread, :thread_url, :content, :status

    def initialize(id, petition_response = false)
      @id_thread = id
      @thread_url = ForoCochesAPI::UrlConstructor.buildThreadURL(id)
      loadContent(@thread_url, petition_response) 
      @thread_parsed = Nokogiri::HTML(self.content)
      @status = getStatusOfThread
    end

    def hasNeverBeenCreated?
      panel_content = ""

      @thread_parsed.search("div.panel div div").each do |panel_information|
        panel_content = panel_information.text
      end

      return panel_content == "Ningún Tema especificado."
    end

    def isCensoredThread?
      panel_content = ""

      @thread_parsed.search("div.panel div div strong").each do |panel_information|
        return true if panel_information.text == "EL TEMA QUE NECESITAS VER ESTÁ DISPONIBLE PARA USUARIOS REGISTRADOS CON INVITACIÓN" 
      end

      false
    end

    def isDeletedThread?
      panel_content = ""

      @thread_parsed.search("div.panel div div center").each do |panel_information|
        panel_content = panel_information.text
      end

      return panel_content == "Tema especificado inválido."
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

      return time_of_posters[0].strip
    end

    def created_time
      return false if getStatusOfThread != 1

      @thread_parsed.search('table.tborder-author td.thead').each do |author_time_information|
        return author_time_information.text.strip
      end
    end

    def category
      return false if getStatusOfThread != 1

      @thread_parsed.search("span.navbar a").each_with_index do |navbar_category_container, index|
        return navbar_category_container.text if index == 2
      end
    end

    private

    def performPetition(url)
      @petition = Net::HTTP.get_response(URI(url))
      @content = @petition.body
    end

    def loadContent(url, petition_response)
      @content = petition_response if petition_response
      performPetition(@thread_url)
    end

    def listOfPosters
      @list_of_posters = []

      @thread_parsed.search('tr[@valign="top"]').each do |posts_informations|
        posts_informations.search('a.bigusername').each do |poster|
          @list_of_posters.push(poster.text)
        end
      end

      @list_of_posters
    end

    def listOfTimeOfPosters
      @list_of_time = []

      @thread_parsed.search('table.tborder td.thead').each_with_index do |time_information, index|
        time = time_information.text
        @list_of_time.push(time)
      end 

      @list_of_time
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
  end
end