class UserWorkartsController < ApplicationController
  before_action :authenticate_user!

  def create
    @workart = Workart.find(params[:workart_id])
    @user_workart = current_user.user_workarts.create(workart: @workart, liked: true)

    respond_to do |format|
      format.json { render json: { id: @user_workart.id }, status: :created }
      format.html { redirect_to @workart }
    end
  end

  def destroy
    @user_workart = current_user.user_workarts.find(params[:id])
    @user_workart.destroy

    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to @user_workart.workart }
    end
  end
end
