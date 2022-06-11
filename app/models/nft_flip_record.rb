class NftFlipRecord < ApplicationRecord
  belongs_to :nft
  belongs_to :fliper
end
