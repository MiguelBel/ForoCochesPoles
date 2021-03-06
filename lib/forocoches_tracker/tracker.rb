module ForoCochesTracker
  class Database
    attr_reader :number_of_petitions, :initial_thread, :last_thread

    def initialize(number_of_petitions = 100)
      @number_of_petitions = number_of_petitions.to_i
      @initial_thread = getInitialThread
      @last_thread = @initial_thread + @number_of_petitions - 1
    end

    def getInitialThread
      last_thread = getLastTrackedThread
      return last_thread.id_thread + 1 if last_thread
      1
    end

    def getLastTrackedThread
      Poles.last
    end

    def individualTrack
      doTheIndividualPetitions
    end

    def bulkTrack
      createEmptyRecords
      fillEmptyRecords
    end

    def doTheIndividualPetitions
      polemans = []
      (@initial_thread..@last_thread).each do |thread_number|
        thread = ForoCochesAPI::PetitionManager.new(thread_number)
        insertInDatabase(thread)
      end
    end

    def createEmptyRecords
      (@initial_thread..@last_thread).each do |thread_number|
        createEmptyRecord(thread_number)
      end
    end

    def createEmptyRecord(thread_number)
      Poles.create(:id_thread => thread_number, :status => "pending")
    end

    def fillEmptyRecords
      (@initial_thread..@last_thread).each do |thread_number|
        thread = ForoCochesAPI::PetitionManager.new(thread_number)
        fillEmptyRecord(thread_number, thread)
      end
    end

    def fillEmptyRecord(thread_number, thread)
      record = Poles.where("id_thread = ?", thread_number).first
      data = prepareData(thread)
      record.update(:poleman => data[:poleman], :category => data[:category], :op_time => data[:op_time], :pole_time => data[:pole_time], :status => data[:status])
:wa
    end

    def insertInDatabase(thread)
      data = prepareData(thread)
      Poles.create(:id_thread => data[:thread_id], :poleman => data[:poleman], :category => data[:category], :op_time => data[:op_time], :pole_time => data[:pole_time], :status => data[:status])
    end

    def getDatabaseStatus(thread)
      return "deleted" if thread.status == 4
      return "censored" if thread.status == 3
      return "no_pole_yet" if thread.status == 1 && thread.poleman.nil?

      return 'ok'
    end

    private

    def prepareData(thread)
      poleman = thread.poleman
      category = thread.category
      op_time = thread.created_time
      pole_time = thread.pole_time
      status = getDatabaseStatus(thread)

      {
        thread_id: thread.id_thread,
        poleman: poleman,
        category: category,
        op_time: op_time,
        pole_time: pole_time,
        status: status
      }
    end
  end
end