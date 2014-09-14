require 'spec_helper'

describe "URL constructor" do

  context "Tests about thread urls" do

    it "The main url should be correct" do
      thread_url = "http://www.forocoches.com/foro/showthread.php?t="
      expect(thread_url).to eq(FCURL.thread_url)
    end

    it "Getting the url of thread from id" do
      basic_id = 288
      from_id_to_url = "http://www.forocoches.com/foro/showthread.php?t=#{basic_id}"
      expect(from_id_to_url).to eq (FCURL.buildThreadURL(basic_id))
    end

    it "Getting the url of thread from id and page" do
      basic_id = 288
      page = 28
      from_id_and_page_to_url = "http://www.forocoches.com/foro/showthread.php?t=#{basic_id}&page=#{page}"
      expect(from_id_and_page_to_url).to eq (FCURL.buildThreadURLWithPage(basic_id, page))
    end
    
    it "Retrive the id from an url" do
      basic_id = 288
      from_url_to_id = "http://www.forocoches.com/foro/showthread.php?t=#{basic_id}"
      expect(basic_id).to eq (FCURL.retrieveIDFromURL(from_url_to_id))
    end

  end

end