class UsersController < ApplicationController
  def login
    user = Fliper.where(address: params[:address]).first_or_create
    session[:user_id] = user.id
    SyncFlipRecordsJob.perform_later(user)

    redirect_to user_path(user.address), notice: "Sync data successfully, please reload page after 5 minutes"
  end

  def logout
    session[:user_id] = nil if session[:user_id]

    render json: {success: true}
  end

  def show
    @user = Fliper.find_by(address: params[:address])

    data = FlipChartService.new(start_at: Time.now - 1.week, fliper_address: @user.address)
    @flip_data_chart = data.get_flip_data
    @flip_profit_chart = data.get_flip_profit
  end

  def sync_flip_records
    user = Fliper.find_by id: session[:user_id]

    SyncFlipRecordsJob.perform_later(user)

    redirect_to user_path(user.address), notice: "Sync data successfully, please reload page after 5 minutes"
  end
end
