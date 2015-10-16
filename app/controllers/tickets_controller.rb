class TicketsController < ApplicationController
	before_action :authenticate

	def new
		raise ActionController::RoutingError, '로그인후 TicketController#new에 접속해 주세요'
	end

	def create
		ticket = current_user.tickets.build do |t|
			t.event_id = params[:event_id]
			t.comment = params[:ticket][:comment]
		end
		if ticket.save
			flash[:notice] = '이벤트에 참가등록 하였습니다.'
			head 201
		else
			render json: { messages: ticket.errors.full_messages }, status: 422
		end
	end

	def destroy
		ticket = current_user.tickets.find_by!(event_id: params[:event_id])
		ticket.destroy!
		redirect_to event_path(params[:event_id]), notice: '이벤트 참가를 취소하였습니다'
	end
end
