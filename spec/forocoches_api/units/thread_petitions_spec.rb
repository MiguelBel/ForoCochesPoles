require 'rspec'
require 'spec_helper'

describe ForoCochesAPI::PetitionManager do

  context "Getting the main aspects of the petitions" do

    it "Get the default url on initialize" do
      id = 11
      default_url = ForoCochesAPI::UrlConstructor.buildThreadURL(id)

      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(default_url).to eq(thread.thread_url)
      end
    end

    it "Get the body content of first page (default_page)" do
      id = 11

      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.content.class).to be String
      end
    end

  end

  context "Getting the status of the thread" do

    it "Is a never created thread" do
      id = 10000000000000000

      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.hasNeverBeenCreated?).to be true
      end
    end

    it "Is not a never created thread" do
      id = 11

      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.hasNeverBeenCreated?).to be false
      end
    end


    it "Is a censored thread" do
      id = 3902693
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.isCensoredThread?).to be true
      end
    end

    it "Is not a censored thread" do
      id = 11
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.isCensoredThread?).to be false
      end
    end

    it "Is a deleted thread" do
      id = 3875766
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.isDeletedThread?).to be true
      end
    end

    it "Is not a deleted thread" do
      id = 11
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.isDeletedThread?).to be false
      end
    end
  end

  context "Getting the poleman" do

    it "Try some threads with poleman" do
      id = 288
      poleman = "GATT"
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.poleman).to eq(poleman)
      end

      id = 3411406
      poleman = "Adonai_Segovia"
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.poleman).to eq(poleman)
      end
    end

    it "Have no poleman" do
      id = 117249
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.poleman).to eq(nil)
      end
    end

    it "Cannot because is a deleted thread" do
      id = 3875766
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.poleman).to be nil
      end
    end

    it "Cannot because is a censored thread" do
      id = 3902693
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.poleman).to be nil
      end
    end

    it "Cannot because is a never created thread" do
      id = 10000000000000000
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.poleman).to be nil
      end
    end

  end

  context "With having the outside content" do

    it "the poleman is the right" do
      id = 288
      poleman = "GATT"
      VCR.use_cassette("thread_#{id}") do
        thread_previous = ForoCochesAPI::PetitionManager.new(id)
        thread = ForoCochesAPI::PetitionManager.new(id, thread_previous.content)
        expect(thread.poleman).to eq(poleman)
      end
    end

  end

  context "Getting the category of the thread" do

    it "Try some threads with poleman" do
      id = 288
      category = "ForoCoches" # 4, the id of the category is the four
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.category).to eq(category)
      end

      id = 3411406
      category = "General" # 2, the id of the category is the two
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.category).to eq(category)
      end
    end

    it "Cannot because is a deleted thread" do
      id = 3875766
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.category).to be nil
      end
    end

    it "Cannot because is a censored thread" do
      id = 3902693
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.category).to be nil
      end
    end

    it "Cannot because is a never created thread" do
      id = 10000000000000000
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.category).to be nil
      end
    end

  end

  context "Getting the time of polemans" do

    it "Try some threads with poleman time" do
      id = 288
      pole_time = "31-mar-2003, 02:36"
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.pole_time).to eq(pole_time)
      end

      id = 3411406
      pole_time = "22-sep-2013, 21:02"
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.pole_time).to eq(pole_time)
      end
    end

    it "Try some threads with op time" do
      id = 288
      created_time = "31-mar-2003, 00:06"
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.created_time).to eq(created_time)
      end

      id = 3411406
      created_time = "22-sep-2013, 20:54"
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.created_time).to eq(created_time)
      end
    end

    it "Have no poleman" do
      id = 117249
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.pole_time).to eq(nil)
      end
    end

    it "Cannot because is a deleted thread" do
      id = 3875766
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.pole_time).to be nil
      end
    end

    it "Cannot because is a censored thread" do
      id = 3902693
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.pole_time).to be nil
      end
    end

    it "Cannot because is a never created thread" do
      id = 10000000000000000
      VCR.use_cassette("thread_#{id}") do
        thread = ForoCochesAPI::PetitionManager.new(id)
        expect(thread.pole_time).to be nil
      end
    end

  end

end