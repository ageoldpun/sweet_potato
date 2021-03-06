class EventsController < ApplicationController 
  before_filter :set_return_path, only: [:new, :create]
  before_filter :authenticate_user!, only: [:new, :create]

  helper_method :sort_column, :sort_direction

  def new
    @event = Event.new
  end

  def index
    @events = Event.order(sort_column + " " + sort_direction)
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
       flash[:success] = "Your retreat has been added!"
      redirect_to @event
    else
      render 'new' 
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:id])
      flash[:success] = "Your retreat has been edited!"
      redirect_to @event
    else
      render 'edit'
    end
    
    # current_user.engage!(@event)
    # flash[:success] = "You have engaged with the retreat!"
    # redirect_to @event
  end

  def destroy
    @event = Event.find(params[:id])
    current_user.disengage!(@event)
    flash[:success] = "You have disengaged with the retreat!"
    redirect_to @event
  end

  private

    def event_params
      params.require(:event).permit(:title, :address_1, :address_2, :state, :zip_code, :e_id, :organizer_id, 
                                    :venue, :restrictions, :tradition, :description, :preparations, :instructions,
                                    :code_conduct, :comments, :capacity, :start_date, :end_date)
    end

    def sort_column
      Event.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end


end

