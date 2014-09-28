helpers do

  def mainPageController
    number_of_tracked_threads = Poles.all(:fields => [:id, :category, :poleman]).count
    number_of_censored_threads = Poles.all(:poleman => "", :category => "",:fields => [:id]).count
    number_of_no_poleman_threads = Poles.all(:poleman => "", :category.not => "",:fields => [:id]).count
    number_of_general_threads = Poles.all(:category => "General", :fields => [:id]).count
    last_thread_date = Poles.last(:fields => [:pole_time]).pole_time
    erb :main_page, :layout => nil, :locals => {:number_of_tracked_threads => number_of_tracked_threads, :number_of_censored_threads => number_of_censored_threads, :number_of_no_poleman_threads => number_of_no_poleman_threads, :number_of_general_threads => number_of_general_threads, :last_thread_date => last_thread_date}
  end

end