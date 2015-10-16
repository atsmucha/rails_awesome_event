class EventsController < ApplicationController
	before_action :authenticate, except: :show

	def new
		@event = current_user.created_events.build
	end

	def create
		@event = current_user.created_events.build(event_params)
		if @event.save
			redirect_to @event, notice:'추가하였습니다.'
		else
			render :new
		end
	end
	
	def jsonshow
		@event = Event.find(params[:id])
		respond_to do | format |
			format.json
		end
	end

	def show
		@event = Event.find(params[:id])
		@ticket = current_user && current_user.tickets.find_by(event_id: params[:id])
		@tickets = @event.tickets.includes(:user).order(:created_at)
		respond_to do | format |
			format.json
		end
	end

	def edit
		@event = current_user.created_events.find(params[:id])
	end

	def update
		@event = current_user.created_events.find(params[:id])
		if @event.update(event_params)
			redirect_to @event, notice:'수정하였습니다.'
		else
			render :edit
		end
	end

	def destroy
		@event = current_user.created_events.find(params[:id])
		@event.destroy!
		redirect_to root_path, notice: '삭제하였습니다.'
	end

	private
	def	event_params
		params.require(:event).permit(
						:name, :place, :event_image, :event_image_cache, :remove_event_image, :content, :start_time, :end_time)
	end

end
