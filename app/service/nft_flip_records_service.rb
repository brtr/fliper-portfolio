require 'open-uri'

class NftFlipRecordsService
  class << self
    def fetch_flip_data(fliper, start_at: nil, end_at: nil, cursor: nil)
      end_at ||= Time.now.to_i
      start_at ||= (end_at - 1.month).to_i

      url = "https://api.opensea.io/api/v1/events?only_opensea=false&event_type=successful&occurred_after=#{start_at}&occurred_before=#{end_at}&account_address=#{fliper.address}"
      url += "&cursor=#{cursor}" if cursor
      begin
        response = URI.open(url, {"X-API-KEY" => ENV["OPENSEA_API_KEY"]}).read
        if response
          data = JSON.parse(response)
          events = data["asset_events"]
          events.each do |event|
            asset = event["asset"]
            seller = event["seller"]["address"].downcase
            contract = asset["asset_contract"]
            schema_name = contract["schema_name"] rescue ""
            next if asset.nil? || asset["num_sales"] < 2 || !["ERC721", "METAPLEX"].include?(schema_name) || seller != fliper.address.downcase
            token_address = contract["address"]
            slug = asset["collection"]["slug"]
            token_id = schema_name == "ERC721" ? asset["token_id"] : asset["name"].split("#").last
            last_trade = fetch_last_trade(token_address, seller, slug, token_id, schema_name)
            next unless last_trade.present?
            nft = Nft.where(address: token_address, opensea_slug: slug).first_or_create
            chain_id = schema_name == "ERC721" ? 1 : 101
            nft.update(logo: contract["image_url"], banner: asset["collection"]["banner_image_url"], chain_id: chain_id)
            update_flip_record(nft, last_trade, event, asset, token_id, fliper.id)
          end

          sleep 1
          fetch_flip_data(fliper, start_at: start_at, end_at: end_at, cursor: data["next"]) if data["next"].present?
        end
      rescue => e
        puts "Fetch opensea Error: #{e}"
      end
    end

    def fetch_last_trade(token_address, user_address, slug, token_id, schema_name)
      result = {}
      sleep 1
      begin
        if schema_name == "ERC721"
          url = "https://api.opensea.io/api/v1/events?only_opensea=false&token_id=#{token_id}&asset_contract_address=#{token_address}&event_type=successful&account_address=#{user_address}"
        else
          url = "https://api.opensea.io/api/v1/events?only_opensea=false&collection_slug=#{slug}&event_type=successful&account_address=#{user_address}"
        end
        response = URI.open(url, {"X-API-KEY" => ENV["OPENSEA_API_KEY"]}).read
        if response
          data = JSON.parse(response)
          events = data["asset_events"]
          e = events.select{|e| e["winner_account"]["address"] == user_address}.first
          if e
            asset = e["asset"]
            if asset["asset_contract"]["schema_name"] == "METAPLEX"
              return false if asset["name"].split("#").last != token_id
              cost = e["total_price"].to_f / 10 ** 9
              result = {bought_coin: "SOL", cost: cost, cost_usd: 0, from_address: e["seller"]["address"], trade_time: e["created_date"]}
            else
              return false if asset["token_id"] != token_id
              payment = e["payment_token"]
              coin = payment["symbol"]
              return false unless coin.in?(["ETH", "WETH"])
              cost = e["total_price"].to_f / 10 ** payment["decimals"].to_i
              cost_usd = cost * payment["usd_price"].to_f
              result = {bought_coin: coin, cost: cost, cost_usd: cost_usd, from_address: e["seller"]["address"], trade_time: e["created_date"]}
            end
          end
          return result
        end
      rescue => e
        puts "Fetch opensea Error: #{e}"
      end
    end

    private
    def update_flip_record(nft, last_trade, event, asset, token_id, fliper_id)
      if last_trade[:bought_coin] == "SOL"
        price = event["total_price"].to_f / 10 ** 9
        price_usd = 0
        sold_coin = last_trade[:bought_coin]
      else
        payment = event["payment_token"]
        price = event["total_price"].to_f / 10 ** payment["decimals"].to_i
        price_usd = price * payment["usd_price"].to_f
        sold_coin = payment["symbol"]
      end

      cost = last_trade[:cost]
      revenue = price - cost
      roi = cost == 0 ? 0 : revenue / cost

      cost_usd = last_trade[:cost_usd]
      revenue_usd = price_usd - cost_usd
      roi_usd = cost_usd == 0 ? 0 : revenue_usd / cost_usd
      sold_time = DateTime.parse(event["created_date"])
      bought_time = DateTime.parse(last_trade[:trade_time])
      gap = sold_time.to_i - bought_time.to_i
      r = nft.nft_flip_records.where(fliper_id: fliper_id, slug: nft.opensea_slug, token_address: asset["asset_contract"]["address"], token_id: token_id, txid: event["transaction"]["transaction_hash"]).first_or_create
      r.update( sold: price, sold_usd: price_usd, bought: cost, bought_usd: cost_usd, revenue: revenue, roi: roi, gap: gap, revenue_usd: revenue_usd, roi_usd: roi_usd,
                sold_time: sold_time, bought_time: bought_time, sold_coin: sold_coin, bought_coin: last_trade[:bought_coin], permalink: asset["permalink"],
                image: asset["image_url"], from_address: last_trade[:from_address], fliper_address: event["seller"]["address"], to_address: event["winner_account"]["address"])
    end
  end
end