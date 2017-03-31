class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @articles = Article.paginate(page: params[:page]).per_page(5)
    @articles_count = Article.all.size;
  end
  
  def new
    authorize! :create, Article
    @article = Article.new
  end
  
  def show
    @comments = @article.comments.paginate(page: params[:page]).per_page(10)
    @comments_count = @article.comments.size
    authorize! :read, @article
  end
  
  def edit
    authorize! :update, @article
  end
  
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:notice] = "Article create"
      redirect_to articles_path
    else
      flash[:error] = "Error article create"
      render :new
    end
  end
  
  def update
    if @article.update(article_params)
      flash[:notice] = "Article update"
      redirect_to articles_path
    else
      flash[:error] = "Error article update"
      render :edit
    end
  end
  
  def destroy
    authorize! :destroy, @article
    @article.destroy
    redirect_to articles_path
  end
  
  private
  def article_params
    params.require(:article).permit(:name, :description, :content);
  end
  
  def find_article
    @article = Article.find(params[:id])
  end
  
end
