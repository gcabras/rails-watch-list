class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
    @list = List.find(params[:list_id])
  end

  def create
    @bookmark = Bookmark.create(bookmarks_params)
    @list = List.find(params[:list_id])
    @movie = Movie.find(bookmarks_params[:movie_id])
    @bookmark.user = current_user
    @bookmark.list = @list
    @bookmark.movie = @movie
    @bookmark.save
    if @bookmark.save
      redirect_to list_path(@list)
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @list = List.find(@bookmark.list_id)
    @bookmark.destroy
    redirect_to list_path(@list)
  end

  private

  def bookmarks_params
    params.require(:bookmark).permit(:comment, :list_id, :movie_id)
  end
end
