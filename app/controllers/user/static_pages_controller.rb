class User::StaticPagesController < User::BaseController
  skip_load_and_authorize_resource
  def home; end
end
