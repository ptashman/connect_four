class DiscsController < ApplicationController

  # DELETE /discs
  def delete_all
    Disc.destroy_all
    redirect_back(fallback_location: root_path)
  end
end
