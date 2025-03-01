class WorkartsController < ApplicationController
  before_action :set_workart, only: :show

  # GET /workarts or /workarts.json
  def index
    @workarts = Workart.all
    # The `geocoded` scope filters only workarts with coordinates
    @markers = @workarts.geocoded.map do |workart|
      {
        name: workart.workart_title,
        address: workart.address,
        lat: workart.latitude,
        lng: workart.longitude
      }
    end
  end

  # GET /workarts/1 or /workarts/1.json
  def show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_workart
      @workart = Workart.find(params[:id])
    end
end
