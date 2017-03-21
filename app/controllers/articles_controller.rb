class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @articles = Article.all
  end
  
  def new
    @article = Article.new
  end
  
  def show
  end
  
  def edit
  end
  
  def create
    @article = Article.new(articles_param)
    if @article.save
      flash[:notice] = "Article create"
      redirect_to articles_path
    else
      flash[:error] = "Error article create"
      render :new
    end
  end
  
  def update
    if @article.update(articles_param)
      flash[:notice] = "Article update"
      redirect_to articles_path
    else
      flash[:error] = "Error article update"
      render :edit
    end
  end
  
  def destroy
    @article.destroy
    redirect_to articles_path
  end
  
  private
  def articles_param
    params.require(:article).permit(:name, :description, :content);
  end
  
  def find_article
    @article = Article.find(params[:id])
  end
  
end
