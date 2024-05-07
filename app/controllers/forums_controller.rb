class ForumsController < ApplicationController
  def index
    comments = Forum.all
    render json: comments
  end

  def show
    movie_api_id = Forum.where(tmdb_api_id: params[:id])
    # p movie_api_id.is_a?(Array)
    # if movie_api_id.is_a?(Array)
      render json: movie_api_id
    # else
    #   render json: movie_api_id.errors, status: 422
    # end
  end

  def create
    comment = Forum.create(forum_params)
    if comment.valid?
      render json: comment
    else
      render json: comment.errors, status: 422
    end
  end

  def update
    comment = Forum.find(params[:id])
    comment.update(forum_params)
    if comment.valid?
      render json: comment
    else
      render json: comment.errors, status: 422
    end
  end

  def destroy
    comment = Forum.find(params[:id])
    comment.destroy
  end

  private
  def forum_params
    params.require(:forum).permit(:tmdb_api_id, :comment, :username, :user_id)
  end
end
