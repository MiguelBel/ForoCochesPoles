module ForoCochesAPI
  class UrlConstructor 
    class << self
      def buildThreadURL(id)
        "#{thread_url}#{id}"
      end

      def buildThreadURLWithPage(id, page)
        "#{buildThreadURL(id)}&page=#{page}"
      end

      def retrieveIDFromURL(url)
        url.gsub(thread_url, "").to_i
      end

      def thread_url
        "http://www.forocoches.com/foro/showthread.php?t="
      end
    end
  end
end