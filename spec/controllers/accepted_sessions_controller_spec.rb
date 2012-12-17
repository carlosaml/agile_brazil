# encoding: UTF-8
require 'spec_helper'
 
describe AcceptedSessionsController do
  render_views

  it_should_require_login_for_actions :index

  before(:each) do
    @conference = FactoryGirl.create(:conference)
    user = FactoryGirl.create(:user)
    sign_in user
    disable_authorization
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "index action should find accepted sessions" do
    Session.stubs(:for_user).returns(Session)
    Session.expects(:for_conference).at_least(1).with(@conference).returns(Session)
    Session.expects(:with_state).at_least(1).with(:accepted).returns([])
    get :index
    assigns(:sessions).should == []
  end

end
