require 'uri'
require 'net/http'

class NearApi
  def initialize
    @uri = URI("https://4816b0d3-d97d-47c4-a02c-298a5081c0f9.mock.pstmn.io/near/transactions?api_key=#{ENV['NEAR_API_KEY']}")
  end

  def fetch_transactions
    res = Net::HTTP.get_response(@uri)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end
end