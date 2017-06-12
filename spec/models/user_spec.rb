require 'rails_helper'

describe User do
  
  before{@user = User.new(username: "name1", email:"name1@mail.com", password:"foobar", password_confirmation:"foobar")}
  
  subject{@user}
  
  it{should respond_to(:username)}
  it{should respond_to(:admin)}
  it{should respond_to(:articles)}
  it{should respond_to(:comments)}
  
  it{should be_valid}
  it{should_not be_admin}
  
  describe "For admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it{should be_admin}
  end
  
end
