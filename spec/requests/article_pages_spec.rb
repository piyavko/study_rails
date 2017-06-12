require 'rails_helper'

describe "Article pages" do
  before{visit articles_path}
  subject{page}
  
  describe "Article show" do
    let(:user){FactoryGirl.create(:user)}
    let(:article){FactoryGirl.create(:article, user:user)}
    
    describe "Show when not sign in" do
      before{visit article_path(article)}
      it{should have_selector("h1", text:article.name)}
      it{should have_content(article.content)}
      it{should have_content(article.user.username)}
      it{should have_content(article.user.email)}
      it{should have_link("Back")}
      it{should_not have_link("Edit", href:edit_article_path(article))}
      it{should_not have_link("Delete")}
      it{should have_content("Comments")}
    end
    
    describe "Show when sign in" do
      before do
        sign_in user
        visit article_path(article)
      end
      it{should have_link("Edit", href:edit_article_path(article))}
      it{should have_link("Delete", href:article_path(article))}
    end
    
    describe "Show when other user sign in" do
      let(:user2){FactoryGirl.create(:user, email:"name2@mail.com")}
      before do
        sign_in user2
        visit article_path(article)
      end
      it{should_not have_link("Edit", href:edit_article_path(article))}
      it{should_not have_link("Delete", href:article_path(article))}
    end
    
    describe "Show when admin sign in" do
      let(:admin){FactoryGirl.create(:admin, email:"admin@mail.com")}
      before do
        sign_in admin
        visit article_path(article)
      end
      it{should have_link("Edit", href:edit_article_path(article))}
      it{should have_link("Delete", href:article_path(article))}
    end
  end
  
  describe "New article" do
    describe "When not sign in" do
      before{click_link "New article"}
      it{should have_selector("h1", text:"Sign in")}
    end
    
    describe "When sign in" do
      let(:user){FactoryGirl.create(:user)}
      before do
        sign_in user
        click_link "New article"
      end
      
      it{should have_selector("h1", text:"New Article")}
      
      describe "Create invalid article" do
        before{click_button "Create Article"}
        it{should have_selector("h1", text:"New Article")}
        it{should have_content("error")}
      end
      
      describe "Create valid article" do
        let(:article){FactoryGirl.create(:article, user:user)}
        before{fill_article(article)}
        it{expect{click_button "Create Article"}.to change(Article, :count).by(1)}
      end
    end
  end
  
  describe "Article edit" do
    let(:user){FactoryGirl.create(:user)}
    let(:article){FactoryGirl.create(:article, user:user)}
    
    describe "When not sign in" do
      describe "Visiting edit page" do
        before{visit edit_article_path(article)}
        it{should have_selector("h1", text:"Sign in")}
      end
      describe "submitting to the update action" do
        before{patch article_path(article)}
        it{expect(response).to redirect_to(new_user_session_path)}
      end
    end
      
    describe "When sign in" do
      before do
        sign_in user
        visit edit_article_path(article)
      end
      
      it{should have_selector("h1", text:"Edit Article")}
      
      describe "Edit page" do
        let(:new_name){"Name 2"}
        before do
          fill_in "Name", with: new_name
          click_button "Update Article"
        end
        
        it{should have_content("Articles")}
        it{should have_content("Article update")}
        it{should have_content(new_name)}
        it{expect(article.reload.name).to eq new_name}
      end
    end
  end
  
  describe "Article delete" do
    let(:user){FactoryGirl.create(:user)}
    let(:article){FactoryGirl.create(:article, user:user)}
    
    describe "When not sign in" do
      before{delete article_path(article)}
      it{expect(response).to redirect_to(new_user_session_path)}
    end
    
    describe "When sign in" do
      before do
        sign_in user
        visit article_path(article)
      end
      it{expect{click_link "Delete"}.to change(Article, :count).by(-1)}
    end
  end
  
  describe "Ctrl destroy associated articles if user deleted" do
    let(:user){FactoryGirl.create(:user)}
    before do
      FactoryGirl.create(:article, user:user)
      FactoryGirl.create(:article, user:user)
    end
    it "Should destroy associated comments" do
      articles = user.articles.to_a
      user.destroy
      expect(articles).not_to be_empty
      articles.each do |article|
        expect(Article.where(id: article.id)).to be_empty
      end
    end
  end
end
