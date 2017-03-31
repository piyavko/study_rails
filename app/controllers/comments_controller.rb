class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to @article
  end
  
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
    redirect_to @article
  end
  
  private
  def comment_params
    params.require(:comment).permit(:comment);
  end
end
