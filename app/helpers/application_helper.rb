module ApplicationHelper
  def current_user
    @current_user ||= Fliper.find_by(id: session[:user_id])
  end

  def date_format(datetime)
    datetime.strftime('%Y-%m-%d')
  end

  def get_logo(logo_url)
    logo_url || asset_url("placeholder.png")
  end

  def is_admin?
    admin_ids = ENV.fetch("ADMIN_IDS"){""}.split(',')
    current_user && current_user.id.to_s.in?(admin_ids)
  end

  def address_format(address)
    address[6...-4] = "...."
    address
  end

  def decimal_format(data)
    data.to_f.round(3)
  end

  def humanize_gap(gap)
    gap = gap.to_f
    if gap < 86400
      hours = gap / 3600
      "#{hours.round(2)} hours"
    else
      days = (gap / 86400).to_i
      hours = (gap - days * 86400) / 3600
      "#{days} days #{hours.round(2)} hours"
    end
  end
end
