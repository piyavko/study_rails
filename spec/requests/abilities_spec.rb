require 'rails_helper'

describe "Ability" do
  subject{page}
  
  let(:user){FactoryGirl.create(:user)}
  let(:author){FactoryGirl.create(:user, email:"author@mail.com")}
  let(:admin){FactoryGirl.create(:admin, email:"admin@mail.com")}
  let(:article){FactoryGirl.create(:article, user:author)}
  let(:commentUser){FactoryGirl.create(:comment, user:user, article:article, comment:"Comment 1")}
  let(:commentAuthor){FactoryGirl.create(:comment, user:author, article:article, comment:"Comment 2")}
  
  describe "Simple user" do
    describe "Read article" do
      before do
        sign_in user
        visit article_path(article)
      end
      it{should have_selector("h1", text:article.name)}
    end
    
    describe "Create article" do
      describe "Visiting create page" do
        before do
          sign_in user
          visit new_article_path(article)
        end
        it{should have_selector("h1", text:"New Article")}
      end
      
      describe "Submitting to the create action" do
        before do
          sign_in user, no_capybara: true
          post articles_path(Article.new), params:{article:{name:"Name2", description:"Desc2", content:"Content2"}}
        end
        it{expect(flash[:notice]).to eq "Article create"}
        it{expect(response).to redirect_to(articles_path)}
      end
    end
    
    describe "Update article" do
      describe "Visiting edit page" do
        before do
          sign_in user
          visit edit_article_path(article)
        end
        it{should have_content("Access denied")}
        it{expect(page.current_path).to eq root_path}
      end
      
      describe "Submitting to the update action" do
        before do
          sign_in user, no_capybara: true
          patch article_path(article), params:{article:{name:"Name2", description:"Desc2", content:"Content2"}}
        end
        it{expect(flash[:alert]).to eq "Access denied"}
        it{expect(response).to redirect_to(root_path)}
      end
    end
        
    describe "Delete article" do
      before do
        sign_in user, no_capybara: true
        delete article_path(article)
      end
      it{expect(flash[:alert]).to eq "Access denied"}
      it{expect(response).to redirect_to(root_path)}
    end
    
    describe "Create comment" do
      let!(:countComments){article.comments.count}
      before do
        sign_in user, no_capybara: true
        post article_comments_path(article), params:{comment:{comment:"Comment1"}}
      end
      it{expect(article.comments.count).to eq (countComments + 1)}
      it{expect(response).to redirect_to(article_path(article))}
    end
    
    describe "Delete comment" do
      before{sign_in user, no_capybara: true}

      describe "Delete own comment" do
        before{delete article_comment_path(article, commentUser)}
        it{expect(article.comments).not_to include(commentUser)}
        it{expect(response).to redirect_to(article_path(article))}
      end
      
      describe "Delete comment of other user" do
        before{delete article_comment_path(article, commentAuthor)}
        it{expect(flash[:alert]).to eq "Access denied"}
        it{expect(response).to redirect_to(root_path)}
      end
    end
  end
  
  
  describe "Author of article" do
    describe "Update article" do
      describe "Visiting edit page" do
        before do
          sign_in author
          visit edit_article_path(article)
        end
        it{should have_content("Edit Article")}
      end
      
      describe "Submitting to the update action" do
        before do
          sign_in author, no_capybara: true
          patch article_path(article), params:{article:{name:"Name_change", description:article.description, content:article.content}}
        end
        it{expect(flash[:notice]).to eq "Article update"}
        it{expect(article.reload.name).to eq "Name_change"}
        it{expect(response).to redirect_to(articles_path)}
      end
    end
        
    describe "Delete article" do
      before do
        sign_in author, no_capybara: true
        delete article_path(article)
      end
      it{expect(flash[:notice]).to eq "Article delete"}
      it{expect(Article.all).not_to include(article)}
      it{expect(response).to redirect_to(articles_path)}
    end
    
    describe "Delete comment" do
      before{sign_in author, no_capybara: true}

      describe "Delete own comment" do
        before{delete article_comment_path(article, commentAuthor)}
        it{expect(article.comments).not_to include(commentAuthor)}
        it{expect(response).to redirect_to(article_path(article))}
      end
      
      describe "Delete comment of other user" do
        before{delete article_comment_path(article, commentUser)}
        it{expect(article.comments).not_to include(commentUser)}
        it{expect(response).to redirect_to(article_path(article))}
      end
    end
  end
  
  
  describe "Admin" do
    describe "Update article" do
      describe "Visiting edit page" do
        before do
          sign_in admin
          visit edit_article_path(article)
        end
        it{should have_selector("h1", text:"Edit Article")}
      end
      describe "Submitting to the update action" do
        before do
          sign_in admin, no_capybara: true
          patch article_path(article), params:{article:{name:"Name_change", description:article.description, content:article.content}}
        end
        it{expect(flash[:notice]).to eq "Article update"}
        it{expect(article.reload.name).to eq "Name_change"}
        it{expect(response).to redirect_to(articles_path)}
      end
    end
        
    describe "Delete article" do
      before do
        sign_in admin, no_capybara: true
        delete article_path(article)
      end
      it{expect(flash[:notice]).to eq "Article delete"}
      it{expect(Article.all).not_to include(article)}
      it{expect(response).to redirect_to(articles_path)}
    end
    
    describe "Delete comment" do
      before{sign_in admin, no_capybara: true}

      describe "Delete comment of other user" do
        before{delete article_comment_path(article, commentUser)}
        it{expect(article.comments).not_to include(commentUser)}
        it{expect(response).to redirect_to(article_path(article))}
      end
      
      describe "Delete comment of author of article" do
        before{delete article_comment_path(article, commentAuthor)}
        it{expect(article.comments).not_to include(commentAuthor)}
        it{expect(response).to redirect_to(article_path(article))}
      end
    end
  end
end
