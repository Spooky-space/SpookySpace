class ListAddsController < ApplicationController

  def index
    list_adds = ListAdd.all
    render json: list_adds
  end

  def create
    list_add = ListAdd.create(list_add_params)
    if list_add.valid?
      render json: list_add
    else
      render json: list_add.errors, status: 422
    end
  end

  def update
    list_add = ListAdd.find(params[:id])
    list_add.update(list_add_params)
    if list_add.valid?
      render json: list_add
    else
      render json: list_add.errors, status: 422
    end
  end

  def destroy
    list_add = ListAdd.find(params[:id])
    list_add.destroy
  end

  private
  def list_add_params
    params.require(:list_add).permit(:tmdb_api_id, :watched, :rating, :user_id)
  end
end
