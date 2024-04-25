class ListAddsController < ApplicationController

  def index
    listadds = ListAdd.all
    render json: listadds
  end

  def create
    listadd = ListAdd.create(listadd_params)
    if listadd.valid?
      render json: listadd
    else
      render json: listadd.errors, status: 422
    end
  end

  def update
    listadd = ListAdd.find(params[:id])
    listadd.update(listadd_params)
    if listadd.valid?
      render json: listadd
    else
      render json: listadd.errors, status: 422
    end
  end

  def destroy
    listadd = ListAdd.find(params[:id])
    listadd.destroy
  end

  private
  def listadd_params
    params.require(:list_add).permit(:tmdb_api_id, :watched, :rating, :user_id)
  end
end
