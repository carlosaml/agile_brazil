# encoding: UTF-8
class SessionsController < InheritedResources::Base
  actions :all, :except => [:destroy]
  has_scope :for_user, :only => :index, :as => 'user_id'
  before_filter :load_user
  before_filter :load_comment, :only => :show
  before_filter :check_conference, :only => :show
  has_scope :tagged_with, :only => :index
  
  def create
    create! do |success, failure|
      success.html do
        EmailNotifications.session_submitted(@session).deliver
        flash[:notice] = t('flash.session.create.success')
        redirect_to session_path(@session)
      end
      failure.html do
        flash.now[:error] = t('flash.failure')
        render :new
      end
    end
  end
  
  def update
    update! do |success, failure|
      success.html do
        flash[:notice] = t('flash.session.update.success')
        redirect_to session_path(@session)
      end
      failure.html do
        flash.now[:error] = t('flash.failure')
        render :edit
      end
    end
  end
  
  def cancel
    flash[:error] = t('flash.session.cancel.failure') unless resource.cancel
    redirect_to organizer_sessions_path
  end
  
  protected
  def build_resource
    attributes = params[:session] || {}
    attributes[:conference_id] = current_conference.id
    @session ||= end_of_association_chain.send(method_for_build, attributes)
  end

  def load_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end
  
  def load_comment
    @comment = Comment.new(:user_id => current_user.id, :commentable_id => @session.id)
  end

  def check_conference
    if resource.conference != current_conference
      flash.now[:news] = t('flash.news.session_different_conference', :conference_name => resource.conference.name, :current_conference_name => current_conference.name).html_safe
    end
  end

  def collection
    paginate_options ||= {}
    paginate_options[:page] ||= (params[:page] || 1)
    paginate_options[:per_page] ||= (params[:per_page] || 10)
    paginate_options[:order] ||= 'sessions.created_at DESC'
    @sessions ||= end_of_association_chain.for_conference(current_conference).paginate(paginate_options)
  end
  
  def begin_of_association_chain
    action_name == 'new' ? current_user : nil
  end
        
end
