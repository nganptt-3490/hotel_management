class Admin::LostUtilitiesController < Admin::BaseController
  def create
    @lost_utility = LostUtility.new lost_utility_params
    if @lost_utility.save
      handle_successful_save
    else
      handle_failed_save
    end
  end

  private
  def lost_utility_params
    params.require(:lost_utility).permit LostUtility::LOSTUTILITIES_PERMITTED
  end

  def handle_successful_save
    utility = @lost_utility.utility
    if utility
      render json: {
        success: true,
        lost_utility: @lost_utility,
        utility_name: utility.name,
        utility_cost: utility.cost
      }, status: :created
    else
      flash[:danger] = t "record_not_found"
      render json: {success: false, error: t("record_not_found")},
             status: :not_found
    end
  end

  def handle_failed_save
    flash[:danger] = t "failed"
    render json: {success: false, errors: @lost_utility.errors.full_messages},
           status: :unprocessable_entity
  end
end
