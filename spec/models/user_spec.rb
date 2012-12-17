# encoding: UTF-8
# encoding: utf-8
require 'spec_helper'

describe User do
  context "protect from mass assignment" do
    it { should allow_mass_assignment_of :first_name }
    it { should allow_mass_assignment_of :last_name }
    it { should allow_mass_assignment_of :username }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :password }
    it { should allow_mass_assignment_of :password_confirmation }
    it { should allow_mass_assignment_of :phone }
    it { should allow_mass_assignment_of :country }
    it { should allow_mass_assignment_of :state }
    it { should allow_mass_assignment_of :city }
    it { should allow_mass_assignment_of :organization }
    it { should allow_mass_assignment_of :website_url }
    it { should allow_mass_assignment_of :bio }
    it { should allow_mass_assignment_of :wants_to_submit }
    it { should allow_mass_assignment_of :default_locale }

    it { should_not allow_mass_assignment_of :id }
  end
  
  it_should_trim_attributes User, :first_name, :last_name, :username,
                                  :email, :phone, :state, :city, :organization,
                                  :website_url, :bio

  context "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    
    context "brazilians" do
      subject { FactoryGirl.build(:user, :country => "BR") }
      it { should_not validate_presence_of :state }
    end
    
    context "author" do
      subject { FactoryGirl.build(:user).tap {|u| u.add_role("author") } }
      it { should validate_presence_of :phone }
      it { should validate_presence_of :country }
      it { should validate_presence_of :city }
      it { should validate_presence_of :bio }

      it { should allow_value("1234-2345").for(:phone) }
      it { should allow_value("+55 11 5555 2234").for(:phone) }
      it { should allow_value("+1 (304) 543.3333").for(:phone) }
      it { should allow_value("07753423456").for(:phone) }
      it { should_not allow_value("a").for(:phone) }
      it { should_not allow_value("1234-bfd").for(:phone) }
      it { should_not allow_value(")(*&^%$@!").for(:phone) }
      it { should_not allow_value("[=+]").for(:phone) }

      context "brazilians" do
        subject { FactoryGirl.build(:user, :country => "BR").tap {|u| u.add_role("author") } }
        it { should validate_presence_of :state }
      end
    end
    
    it { should ensure_length_of(:username).is_at_least(3).is_at_most(30) }
    it { should ensure_length_of(:password).is_at_least(3).is_at_most(30) }
    it { should ensure_length_of(:email).is_at_least(6).is_at_most(100) }
    it { should ensure_length_of(:first_name).is_at_most(100) }
    it { should ensure_length_of(:last_name).is_at_most(100) }
    it { should ensure_length_of(:city).is_at_most(100) }
    it { should ensure_length_of(:organization).is_at_most(100) }
    it { should ensure_length_of(:website_url).is_at_most(100) }
    it { should ensure_length_of(:phone).is_at_most(100) }
    it { should ensure_length_of(:bio).is_at_most(1600) }

    it { should allow_value("dtsato").for(:username) }
    it { should allow_value("123").for(:username) }
    it { should allow_value("a b c").for(:username) }
    it { should allow_value("danilo.sato").for(:username) }
    it { should allow_value("dt-sato@dt_sato.com").for(:username) }
    it { should_not allow_value("dt$at0").for(:username) }
    it { should_not allow_value("<>/?").for(:username) }
    it { should_not allow_value(")(*&^%$@!").for(:username) }
    it { should_not allow_value("[=+]").for(:username) }

    it { should allow_value("user@domain.com.br").for(:email) }
    it { should allow_value("test_user.name@a.co.uk").for(:email) }
    it { should_not allow_value("a").for(:email) }
    it { should_not allow_value("a@").for(:email) }
    it { should_not allow_value("a@a").for(:email) }
    it { should_not allow_value("@12.com").for(:email) }

    context "uniqueness" do
      subject { FactoryGirl.create(:user, :country => "BR") }
      it { should validate_uniqueness_of(:email).with_message("outro usuário já usou o mesmo e-mail. Por favor escolha outro e-mail") }
      it { should validate_uniqueness_of(:username).case_insensitive }
    end
    
    xit { should validate_confirmation_of :password }
    
    it "should validate that username doesn't change" do
      user = FactoryGirl.create(:user)
      user.username = 'new_username'
      user.should_not be_valid
      user.errors[:username].should == ["não pode mudar"]
    end
  end
  
  context "associations" do
    it { should have_many :sessions }
    it { should have_many :organizers }
    it { should have_many(:all_organized_tracks).through(:organizers) }
    it { should have_many :reviewers }
    it { should have_many :reviews }

    describe "organized tracks for conference" do
      it "should narrow tracks based on conference" do
        organizer = FactoryGirl.create(:organizer)
        user = organizer.user
        FactoryGirl.create(:organizer, :user => user)

        user.organized_tracks(organizer.conference).should == [organizer.track]
      end
    end
    
    describe "#has_approved_session?" do
      it "should not have approved long sessions if never submited" do
         user = FactoryGirl.build(:user)
         user.should_not have_approved_session(FactoryGirl.build(:conference))
      end
      
      it "should not have approved long sessions if accepted was on another conference" do
         user = FactoryGirl.build(:user)
         old_conference = FactoryGirl.build(:conference)
         current = FactoryGirl.build(:conference)
         session = FactoryGirl.build(:session, :author => user, :conference => old_conference)

         user.should_not have_approved_session(current)
      end
      
      it "should have approved long sessions if accepted was lightning talk" do
         user = FactoryGirl.create(:user)
         session = FactoryGirl.create(:session, :author => user, :session_type_id => 4, :duration_mins => 10, :state => 'accepted')

         user.should have_approved_session(session.conference)
      end
      
      it "should have approved long sessions if accepted was not lightning talk" do
         user = FactoryGirl.create(:user)
         session = FactoryGirl.create(:session, :author => user, :session_type_id => 1, :state => 'accepted')

         user.should have_approved_session(session.conference)
      end

      it "should have approved long sessions if accepted contains at least one non lightning talk" do
        user = FactoryGirl.create(:user)
        session = FactoryGirl.create(:session, :author => user, :session_type_id => 1, :state => 'accepted')
        lightning_talk = FactoryGirl.create(:session, :author => user, :session_type_id => 4, :duration_mins => 10,  :state => 'accepted')

        user.should have_approved_session(session.conference)
      end

      it "should not have approved long sessions if no sessions was not accepted" do
        user = FactoryGirl.build(:user)
        session = FactoryGirl.build(:session, :author => user, :session_type_id => 1, :state => 'cancelled')
        lightning_talk = FactoryGirl.build(:session, :author => user, :session_type_id => 4, :duration_mins => 10,  :state => 'rejected')

        user.should_not have_approved_session(session.conference)
      end

      it "should have approved sessions as second author" do
         user = FactoryGirl.create(:user)
         user.add_role :author
         session = FactoryGirl.create(:session, :second_author => user, :session_type_id => 1, :state => 'accepted')

         user.should have_approved_session(session.conference)
      end
    end

    describe "user preferences" do
      it "should return reviewer preferences based on conference" do
        preference = FactoryGirl.create(:preference)
        reviewer = preference.reviewer
        user = reviewer.user
        FactoryGirl.create(:preference, :reviewer => FactoryGirl.build(:reviewer, :user => user))

        user.preferences(reviewer.conference).should == [preference] 
      end
    end
  end
  
  context "named scopes" do
    xit { should have_scope(:search, :with =>'danilo', :where => "username LIKE '%danilo%'") }
  end
  
  context "authorization" do
    it "should have role of author when wants to submit" do
      User.new(:wants_to_submit => '0').should_not be_author
      User.new(:wants_to_submit => '1').should be_author
    end
  end
  
  it "should provide full name" do
    user = User.new(:first_name => "Danilo", :last_name => "Sato")
    user.full_name.should == "Danilo Sato"
  end
  
  it "should provide in_brazil?" do
    user = User.new
    user.should_not be_in_brazil
    user.country = "BR"
    user.should be_in_brazil
  end
  
  it "should overide to_param with username" do
    user = FactoryGirl.create(:user, :username => 'danilo.sato 1990@2')
    user.to_param.ends_with?("-danilo-sato-1990-2").should be_true
    
    user.username = nil
    user.to_param.ends_with?("-danilo-sato-1990-2").should be_false
  end
  
  it "should have 'pt' as default locale" do
    user = FactoryGirl.build(:user)
    user.default_locale.should == 'pt'
  end
end
