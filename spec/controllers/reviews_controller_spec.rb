# encoding: UTF-8
require 'spec_helper'
 
describe ReviewsController do
  render_views

  it_should_require_login_for_actions :index, :show, :new, :create

  before(:each) do
    @review ||= FactoryGirl.create(:review)
    sign_in @review.reviewer
    disable_authorization
  end
  
  it "index action should render author template" do
    get :index, :session_id => Session.first
    response.should render_template(:author)
  end
  
  it "organizer action should render organizer template if user is organizer" do
    get :organizer, :session_id => Session.first
    response.should render_template(:organizer)
  end
  
  it "show action should render show template" do
    get :show, :id => Review.first, :session_id => Session.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new, :session_id => Session.first
    response.should render_template(:new)
    assigns(:review).reviewer.should == @review.reviewer
  end

  it "create action should render new template when model is invalid" do
    # +stubs(:valid?).returns(false)+ doesn't work here because
    # inherited_resources does +obj.errors.empty?+ to determine
    # if validation failed
    post :create, :review => {}, :session_id => Session.first
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Review.any_instance.stubs(:valid?).returns(true)
    post :create, :session_id => Session.first
    response.should redirect_to(session_review_url(assigns(:session), assigns(:review)))
  end
end
