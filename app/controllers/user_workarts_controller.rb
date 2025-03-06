class UserWorkartsController < ApplicationController
  def create
    @workart = Workart.find(params[:workart_id])
    @user_workart = UserWorkart.new(
      user: current_user,
      workart: @workart,
      liked: true
    )

    if @user_workart.save
      redirect_to workart_path(@workart)
    else
      render "workarts/show"
    end
  end

  def destroy
    @user_workart = UserWorkart.find(params[:id])
    @user_workart.destroy
    redirect_to workart_path(@user_workart.workart), status: :see_other
  end
end
