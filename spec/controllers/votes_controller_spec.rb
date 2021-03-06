# encoding: UTF-8
require 'spec_helper'

describe VotesController, :render_views => true do
  render_views

  it "show should work" do
    get :index
  end
end

describe VotesController do

  it_should_require_login_for_actions :index, :create, :destroy

  before(:each) do
    @vote ||= FactoryGirl.create(:vote)
    sign_in @vote.user
    disable_authorization
  end

  describe "#index" do
    before do
      get :index
    end

    subject { assigns(:sessions) }
    it { should == [@vote.session] }
  end

  describe "#create" do
    before do
      @session = FactoryGirl.create(:session)
      @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
      post :create, :vote => {:session_id => @session.id}
    end

    it { should redirect_to('http://test.com/sessions/new') }
    it { @session.votes.should_not be_empty }
  end

  describe "#destroy" do
    before do
      @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
      delete :destroy, :id => @vote.id
    end

    it { should redirect_to('http://test.com/sessions/new') }
    it { lambda { Vote.find(@vote.id) }.should raise_error(ActiveRecord::RecordNotFound) }
  end
end