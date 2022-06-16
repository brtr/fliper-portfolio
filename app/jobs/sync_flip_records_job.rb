class SyncFlipRecordsJob < ApplicationJob
  queue_as :daily_job

  def perform(fliper)
    NftFlipRecordsService.fetch_flip_data(fliper)
  end
end