require 'rails_helper'

describe Comment do
  
  before{@comment = Comment.new(user_id: "1", article_id: "1", comment: "Content 1")}
  
  subject{@comment}
  
  it{should respond_to(:user_id)}
  it{should respond_to(:article_id)}
  it{should respond_to(:comment)}
  
  it{should respond_to(:user)}
  it{should respond_to(:article)}
  
  it{should be_valid}
  
  describe "when user_id is not present" do
    before{@comment.user_id = ""}
    it{should_not be_valid}
  end
  
  describe "when article_id is not present" do
    before{@comment.article_id = ""}
    it{should_not be_valid}
  end
  
  describe "when comment is not present" do
    before{@comment.comment = ""}
    it{should_not be_valid}
  end
  
end
