require 'rails_helper'

describe Article do
  
  let(:user){FactoryGirl.create(:user)}
  before{@article = Article.new(name: "Article 1", description: "Desk 1", content: "Content 1", user_id: user.id)}
  
  subject{@article}
  
  it{should respond_to(:name)}
  it{should respond_to(:description)}
  it{should respond_to(:content)}
  
  it{should respond_to(:user)}
  it{should respond_to(:comments)}
  
  it{should be_valid}
  
  describe "when name is not present" do
    before{@article.name = ""}
    it{should_not be_valid}
  end
  
  describe "when description is not present" do
    before{@article.description = ""}
    it{should_not be_valid}
  end
  
  describe "when content is not present" do
    before{@article.content = ""}
    it{should_not be_valid}
  end
  
  describe "when user_id is not present" do
    before{@article.user_id = ""}
    it{should_not be_valid}
  end
  
  describe "when name is to long" do
    before{@article.name = "a" * 201}
    it{should_not be_valid}
  end
  
  describe "when description is to long" do
    before{@article.description = "a" * 301}
    it{should_not be_valid}
  end
  
end
