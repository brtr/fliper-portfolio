class Fliper < ApplicationRecord
  has_many :nft_flip_records

  def successful_rate
    "#{(nft_flip_records.successful_rate * 100).round(3)} %"
  end

  def flip_count
    nft_flip_records.count
  end

  def flip_gap
    nft_flip_records.sum(&:gap) / flip_count rescue 0
  end

  def flip_revenue
    nft_flip_records.sum(&:revenue)
  end

  def rank
    rank = Fliper.all.sort_by{|f| f.successful_rate}.reverse.index(self)
    rank < 0 ? "-" : rank + 1
  end
end
