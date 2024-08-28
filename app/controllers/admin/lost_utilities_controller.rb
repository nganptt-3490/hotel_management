class Admin::LostUtilitiesController < Admin::BaseController
  def create
    @lost_utility = LostUtility.new lost_utility_params
    if @lost_utility.save
      utility = @lost_utility.utility
      unless utility
        flash[:danger] = t "record_not_found"
        redirect_to admin_path and return
      end

      flash[:success] = t "created"
      render json:
               {success: true, lost_utility: @lost_utility,
                utility_name: utility.name,
                utility_cost: utility.cost},
             status: :created
    else
      flash[:danger] = t "failed"
      render json: {success: false, errors: @lost_utility.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  private
  def lost_utility_params
    params.require(:lost_utility).permit LostUtility::LOSTUTILITIES_PERMITTED
  end
end
