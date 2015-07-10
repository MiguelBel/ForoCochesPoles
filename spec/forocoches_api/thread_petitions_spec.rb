require 'rspec'
require 'spec_helper'

describe "Thread Petitions" do

  context "Getting the main aspects of the petitions" do

    it "Get the default url on initialize" do
      id = 11
      default_url = ForoCochesAPI::UrlConstructor.buildThreadURL(id)
      thread = FCThread.new(id)
      expect(default_url).to eq(thread.default_url)
    end
    
    it "Get the body content of first page (default_page)" do
      id = 11
      thread = FCThread.new(id)
      expect(thread.content.class).to be String
    end 

  end

  context "Getting the status of the thread" do

    it "Is a never created thread" do
      id = 10000000000000000
      thread = FCThread.new(id)
      expect(thread.hasNeverBeenCreated?).to be true  
    end

    it "Is not a never created thread" do
      id = 11
      thread = FCThread.new(id)
      expect(thread.hasNeverBeenCreated?).to be false
    end


    it "Is a censored thread" do
      id = 3902693
      thread = FCThread.new(id)
      expect(thread.isCensoredThread?).to be true 
    end

    it "Is not a censored thread" do
      id = 11
      thread = FCThread.new(id)
      expect(thread.isCensoredThread?).to be false
    end

    it "Is a deleted thread" do
      id = 3875766
      thread = FCThread.new(id)
      expect(thread.isDeletedThread?).to be true
    end

    it "Is not a deleted thread" do
      id = 11
      thread = FCThread.new(id)
      expect(thread.isDeletedThread?).to be false
    end
  end

  context "Getting the poleman" do

    it "Try some threads with poleman" do
      id = 288
      poleman = "GATT"
      thread = FCThread.new(id)
      expect(thread.poleman).to eq(poleman)

      id = 3411406
      poleman = "Adonai_Segovia"
      thread = FCThread.new(id)
      expect(thread.poleman).to eq(poleman)
    end

    it "Have no poleman" do
      id = 117249
      thread = FCThread.new(id)
      expect(thread.poleman).to eq(nil)
    end

    it "Cannot because is a deleted thread" do
      id = 3875766
      thread = FCThread.new(id)
      expect(thread.poleman).to be false
    end    

    it "Cannot because is a censored thread" do
      id = 3902693
      thread = FCThread.new(id)
      expect(thread.poleman).to be false 
    end

    it "Cannot because is a never created thread" do
      id = 10000000000000000
      thread = FCThread.new(id)
      expect(thread.poleman).to be false  
    end
    
  end

  context "With having the outside content" do

    it "the poleman is the right" do
      id = 288
      poleman = "GATT"
      thread_previous = FCThread.new(id)
      thread = FCThread.new(id, thread_previous.content)
      expect(thread.poleman).to eq(poleman)      
    end

  end

  context "Getting the category of the thread" do

    it "Try some threads with poleman" do
      id = 288
      category = "ForoCoches" # 4, the id of the category is the four
      thread = FCThread.new(id)
      expect(thread.category).to eq(category)

      id = 3411406
      category = "General" # 2, the id of the category is the two
      thread = FCThread.new(id)
      expect(thread.category).to eq(category)
    end

    it "Cannot because is a deleted thread" do
      id = 3875766
      thread = FCThread.new(id)
      expect(thread.category).to be false
    end    

    it "Cannot because is a censored thread" do
      id = 3902693
      thread = FCThread.new(id)
      expect(thread.category).to be false 
    end

    it "Cannot because is a never created thread" do
      id = 10000000000000000
      thread = FCThread.new(id)
      expect(thread.category).to be false  
    end

  end

  context "Getting the time of polemans" do

    it "Try some threads with poleman time" do
      id = 288
      pole_time = "31-mar-2003, 02:36"
      thread = FCThread.new(id)
      expect(thread.pole_time).to eq(pole_time)

      id = 3411406
      pole_time = "22-sep-2013, 21:02"
      thread = FCThread.new(id)
      expect(thread.pole_time).to eq(pole_time)
    end

    it "Try some threads with op time" do
      id = 288
      created_time = "31-mar-2003, 00:06"
      thread = FCThread.new(id)
      expect(thread.created_time).to eq(created_time)

      id = 3411406
      created_time = "22-sep-2013, 20:54"
      thread = FCThread.new(id)
      expect(thread.created_time).to eq(created_time)
    end

    it "Have no poleman" do
      id = 117249
      thread = FCThread.new(id)
      expect(thread.pole_time).to eq(nil)
    end

    it "Cannot because is a deleted thread" do
      id = 3875766
      thread = FCThread.new(id)
      expect(thread.pole_time).to be false
    end    

    it "Cannot because is a censored thread" do
      id = 3902693
      thread = FCThread.new(id)
      expect(thread.pole_time).to be false 
    end

    it "Cannot because is a never created thread" do
      id = 10000000000000000
      thread = FCThread.new(id)
      expect(thread.pole_time).to be false  
    end

  end

end