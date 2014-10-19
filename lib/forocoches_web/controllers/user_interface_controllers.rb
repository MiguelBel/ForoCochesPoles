helpers do

  def mainPageController
    erb :main_page, :layout => :template
  end

  def finderController
    required_params_checking = (params[:nick].nil? || params[:nick].strip.empty?)

    if required_params_checking
      erb :no_nick_error, :layout => :template
    else
      number_of_poles = getPolesFrom(params[:nick])
      erb :finder_success, :layout => :template, :locals => {:nick => params[:nick], :number_of_poles => number_of_poles}
    end
  
  end

end