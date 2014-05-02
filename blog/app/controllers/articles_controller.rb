class ArticlesController < ApplicationController
  def new
  end
  def create
   # render plain: params[:article].inspect
    @article = Article.new()
    @article.save
    redirect_to @article  
  end
  private
    def article_parms
      params.require(:article).permit(:title, :text)
    end

end
