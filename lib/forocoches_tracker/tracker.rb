class Tracker
  attr_reader :number_of_petitions
  attr_reader :initial_thread
  attr_reader :last_thread

  def initialize(number_of_petitions = 100)
    @number_of_petitions = number_of_petitions
    @initial_thread = self.getInitialThread
    @last_thread = @initial_thread + @number_of_petitions
  end

  def getInitialThread
    return Poles.last(:fields => [:id_thread]).id_thread
  end

  def track
    self.doThePetitions
  end

  def doThePetitions
    polemans = []
    (@initial_thread..@last_thread).each do |thread_number|
      thread = FCThread.new(thread_number)
      insertInDatabase(thread)
    end
  end

  def insertInDatabase(thread)
    poleman = ""
    category = ""
    op_time = ""
    pole_time = ""
    thread_to_insert_status = self.getDatabaseStatus(thread)

    if thread.status == 1
      poleman = thread.poleman
      category = thread.category
      op_time = thread.created_time
      pole_time = thread.pole_time
    end

    # Solve that, that is because the migration from mysql
    last_id = Poles.last(:fields => [:id]).id

    Poles.create(:id => (last_id + 1), :id_thread => thread.id_thread, :poleman => poleman, :category => category, :op_time => op_time, :pole_time => pole_time, :time => Time.now.to_i, :status => thread_to_insert_status)
  end

  def getDatabaseStatus(thread)
    return "deleted" if thread.status == 4
    return "censored" if thread.status == 3
    return "no_pole_yet" if thread.status == 1 && thread.poleman.nil?
  end
end