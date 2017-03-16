module QuotesHelper

  def ross_quote
    Rails.application.config.quotes.sample
  end

end
