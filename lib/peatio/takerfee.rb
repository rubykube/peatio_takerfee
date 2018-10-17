require 'peatio/services/fee_service'
require 'peatio/services/fee_service/order'
require 'peatio/services/fee_service/withdraw'
require 'peatio/services/fee_service/error'

module Peatio
  module Takerfee
    require 'peatio/takerfee/order'
    require 'peatio/takerfee/withdraw'
    require 'peatio/takerfee/version'

    Peatio::FeeService.order_middlewares    << Order.new
    Peatio::FeeService.withdraw_middlewares << Withdraw.new
  end
end
