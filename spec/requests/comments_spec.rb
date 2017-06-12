require 'rails_helper'

describe "Comments" do
  before{visit articles_path}
  subject{page}
  
  let(:user){FactoryGirl.create(:user)}
  let(:article){FactoryGirl.create(:article, user:user)}
  
  describe "Add comment" do
    let(:comment){"Comment 1"}
    
    describe "When not sign in" do
      before do
        visit article_path(article)
        fill_in "Comment", with: comment
        click_button "Add comment"
      end
      it{should have_selector("h1", text:"Sign in")}
    end

    describe "When sign in" do
      before do
        sign_in user
        visit article_path(article)
      end
      
      describe "If comment empty" do
        before{fill_in "Comment", with: ""}
        it{expect{click_button "Add comment"}.not_to change(Comment, :count)}
      end
      
      describe "If comment not empty" do
        before{fill_in "Comment", with: comment}
        it{expect{click_button "Add comment"}.to change(Comment, :count).by(1)}
      end
    end
  end
  
  describe "View comments" do
    let!(:comment1){FactoryGirl.create(:comment, user:user, article:article, comment:"Comment 1")}
    let!(:comment2){FactoryGirl.create(:comment, user:user, article:article, comment:"Comment 2")}
    before{visit article_path(article)}
    it{should have_content(comment1.comment)}
    it{should have_content(comment2.comment)}
    it{should have_content(article.comments.count)}
  end
  
  describe "Delete comment" do
    let!(:comment){FactoryGirl.create(:comment, user:user, article:article)}
    
    describe "When not sign in" do
      before{delete article_comment_path(comment.article, comment)}
      it{expect(response).to redirect_to(new_user_session_path)}
    end
    
    describe "When sign in" do
      before do
        sign_in user
        visit article_path(article)
      end
      it{expect{click_link("Delete", href:article_comment_path(comment.article, comment))}.to change(Comment, :count).by(-1)}
    end
  end

  describe "Ctrl user for delete comment" do
    let(:user2){FactoryGirl.create(:user, email:"name2@mail.com")}
    let(:admin){FactoryGirl.create(:admin, email:"name3@mail.com")}
    let!(:comment1){FactoryGirl.create(:comment, user:user, article:article, comment:"Comment 1")}
    let!(:comment2){FactoryGirl.create(:comment, user:user2, article:article, comment:"Comment 2")}
    
    describe "If sign in author of article" do
      before do
        sign_in user
        visit article_path(article)
      end
      it{should have_link("Delete", href:article_comment_path(comment1.article, comment1))}
      it{should have_link("Delete", href:article_comment_path(comment2.article, comment2))}
    end
    
    describe "If sign in other user" do
      before do
        sign_in user2
        visit article_path(article)
      end
      it{should_not have_link("Delete", href:article_comment_path(comment1.article, comment1))}
      it{should have_link("Delete", href:article_comment_path(comment2.article, comment2))}
    end
    
    describe "If sign in admin" do
      before do
        sign_in admin
        visit article_path(article)
      end
      it{should have_link("Delete", href:article_comment_path(comment1.article, comment1))}
      it{should have_link("Delete", href:article_comment_path(comment2.article, comment2))}
    end
  end
  
  describe "Ctrl destroy associated comments if article deleted" do
    before do
      FactoryGirl.create(:comment, user:user, article:article)
      FactoryGirl.create(:comment, user:user, article:article)
    end
    it "Should destroy associated comments" do
      comments = article.comments.to_a
      article.destroy
      expect(comments).not_to be_empty
      comments.each do |comment|
        expect(Comment.where(id: comment.id)).to be_empty
      end
    end
  end

end
