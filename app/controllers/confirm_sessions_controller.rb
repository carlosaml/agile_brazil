# encoding: UTF-8
class ConfirmSessionsController < ApplicationController
  before_filter :load_session

  def show
  end
  
  def update
    params[:session][:state_event] = 'accept' if params[:session]
    if @session.update_attributes(params[:session])
      flash[:notice] = t('flash.session.confirm.success')
      redirect_to user_sessions_path(@conference, current_user)
    else
      flash.now[:error] = t('flash.failure')
      render :show
    end
  end
  
  protected
  def load_session
    @session = Session.find(params[:session_id])
  end
end
