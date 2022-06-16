class FlipChartService
  attr_reader :start_at, :end_at, :fliper_address

  def initialize(start_at: nil, end_at: nil, fliper_address: nil)
    @start_at = start_at
    @end_at = end_at || Time.now
    @fliper_address = fliper_address
  end

  def get_flip_data
    records = NftFlipRecord.where(sold_time: [start_at..end_at])
    records = records.where(fliper_address: fliper_address) if fliper_address
    data = records.order(sold_time: :asc).map{|r| [r.revenue, r.sold_time.strftime("%Y-%m-%d %H:%M")]}.uniq
    {
      data: data
    }
  end

  def get_flip_profit
    result = {}
    records = NftFlipRecord.where(sold_time: [start_at..end_at])
    records = records.where(fliper_address: fliper_address) if fliper_address
    records.group_by{|r| r.sold_time.to_date}.sort_by{|date, records| date}.each do |date, records|
      result.merge!({date => {total_profit: records.sum(&:revenue), date: date}})
    end
    result
  end
end