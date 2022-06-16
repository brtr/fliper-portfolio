class NftFlipRecord < ApplicationRecord
  belongs_to :nft
  belongs_to :fliper

  ETH_PAYMENT = ["ETH", "WETH"]

  def is_eth_payment?
    bought_coin.in?(ETH_PAYMENT) && sold_coin.in?(ETH_PAYMENT)
  end

  def is_sol_payment?
    bought_coin == "SOL" && sold_coin == "SOL"
  end

  def same_coin?
    bought_coin == sold_coin || is_eth_payment?
  end

  def self.successful
    select{|n| n.roi_usd > 0 || n.same_coin? && n.roi > 0}
  end

  def self.failed
    select{|n| n.roi_usd < 0 || n.same_coin? && n.roi < 0}
  end

  def self.successful_rate
    all.size == 0 ? 0 : successful.size.to_f / all.size.to_f
  end
end
