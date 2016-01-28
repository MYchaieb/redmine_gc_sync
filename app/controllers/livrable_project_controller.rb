class LivrableProjectController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index

  	@livrable = LivrableProjectEvent.find_by(:project_id => @project.id)
  	if @livrable == nil
  		@livrable = LivrableProjectEvent.new
  	end

    @title_of_event = TitleOfEvent.find_by(:project_id => @project.id)
    if @title_of_event == nil 
      @title_of_event = TitleOfEvent.new
    end

  end

  # def delete_event

  #   p = params['livrable_project_event']
  #   livrable = LivrableProjectEvent.find_by(:project_id => p[:project_id])

  #   if livrable == nil 
  #     flash[:error] = "evenement non trouvée"
  #   else
  #     livrable.destroy
  #     flash[:notice] = "suppression avec succes"
  #   end


  # end

  def save_or_update_title 
    p = params['title_of_event']
    project = Project.find(p[:project_id])
    title_of_event = TitleOfEvent.find_by(:project_id => p[:project_id])
    if title_of_event == nil 
      title_of_event = TitleOfEvent.new
      title_of_event.project_id = p[:project_id]
      title_of_event.title_event = p[:title_event]
    else
      title_of_event.title_event = p[:title_event]
    end

    title_of_event.save
    flash[:notice] = t :title_saved
    redirect_to :back
  end


  def delete_event
    p = params['livrable_project_event']
    livrable = LivrableProjectEvent.find_by(:project_id => p[:project_id])
    if livrable.calendar_ready 
      begin
        livrable.destroy
        flash[:notice] = "suppression avec succes"
        redirect_to :back
      rescue
        flash[:error] = t :error_on_deleating_event
        redirect_to :back
      end
    else
      flash[:error] = t :error_configuration
      redirect_to :back
    end  
  end

  def update_livrable_date

    gottous = LivrableProjectEvent.new

  	updatedat = DateTime.now
  	p = params['livrable_project_event']
  	livrable = LivrableProjectEvent.find_by(:project_id => p[:project_id])

    if gottous.calendar_ready
      log = ''
      project = Project.find(p[:project_id])
      if livrable == nil
        livrable = LivrableProjectEvent.new
        livrable.project_id = project.id
        livrable.created_at = DateTime.now
      else
        log = create_log(livrable, p, updatedat)
      end

      livrable.logs = log
      livrable.updated_at = updatedat
      livrable.description = p[:description]
      livrable.heure = p[:heure]
      livrable.title = p[:title]
      livrable.delivery_date = p[:delivery_date]

      begin
        livrable.save
        flash[:notice] = t :evenement_cree
        redirect_to :back
      rescue
        flash[:error] = t :error_on_creating_event
        redirect_to :back
      end

    else
      flash[:error] = t :error_configuration
      redirect_to :back
    end
  end
  
  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end


  def create_log(livrable, params, updated_at)

  	log = ''

  	if livrable.title != params[:title] || livrable.delivery_date != params[:delivery_date] || livrable.heure != params[:heure] || livrable.description != params[:description] 
  		log = " event Changed on "+ updated_at.to_s+" by : "+ User.current.firstname + " " + User.current.lastname 
  	end

  	if livrable.title != params[:title]
  		
  		log << "\n title changed :" + livrable.title + " => " + params[:title]
  	end

  	if livrable.delivery_date != params[:delivery_date]
  		
  		log << "\n delivery date changed :" + livrable.delivery_date.to_s + " => " + params[:delivery_date].to_s
  	end

    heure = ''

    if livrable.heure != nil
      heure = livrable.heure.strftime "%H:%M"
    end

    newheure = ''
    if params[:heure] != nil && params[:heure] != ""
      time =  Time.parse(params[:heure])
      newheure = time.strftime "%H:%M"
      
    end

  	if heure != newheure
  		
  		log << "\n houre changed :" + heure + " => " + newheure
  	end

  	if livrable.description != params[:description]
  		
  		log << "\n description changed :" + livrable.description + " => " + params[:description]
  	end

    if livrable.logs != nil && livrable.logs != ''
      log << "\n \n"+ livrable.logs 
    end


  	return log
  end
end
