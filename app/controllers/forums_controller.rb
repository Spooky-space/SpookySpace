class ForumsController < ApplicationController
  def index
    comments = Forum.all
    render json: comments
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
