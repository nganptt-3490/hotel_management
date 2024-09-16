class Api::V1::Admin::UtilitiesController < Api::V1::ApplicationController
  before_action :authenticate_user
  before_action :find_utility, only: %i(show update destroy)
  def index
    @pagy, @utilities = pagy(Utility, limit: Settings.pagy.items)
    @start_index = (@pagy.page - 1) * Settings.pagy.items

    render json: {
      utilities: ActiveModelSerializers::SerializableResource
        .new(@utilities, each_serializer: UtilitySerializer),
      pagy: {
        page: @pagy.page,
        items: @pagy.vars[:limit],
        pages: @pagy.pages
      },
      start_index: @start_index
    }
  end

  def show
    render json: @utility
  end

  def create
    @utility = Utility.new utility_params
    if @utility.save
      render json: @utility, status: :created
    else
      render json: @utility.errors, status: :unprocessable_entity
    end
  end

  def update
    if @utility.update utility_params
      render json: @utility, status: :ok
    else
      render json: @utility.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @utility.destroy
    head :no_content
  end

  private
  def find_utility
    @utility = Utility.find_by id: params[:id]
    return if @utility

    render json: {}, status: :not_found
  end

  def utility_params
    params.require(:utility).permit Utility::UTILITY_PERMITTED
  end
end
