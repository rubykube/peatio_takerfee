module Peatio
  module Takerfee
    class Order < Peatio::FeeService::Order
      def on_submit(order)
        Fee.new\
          parent:         order,
          source_account: order.hold_account,
          target_account: Fee::PLATFORM_ACCOUNT_ID,
          amount:         order.locked * 0.001
      end

      def on_complete(order, trade)
        # Don't return fees for market orders.
        return if order.ord_type.to_s == 'market'

        # Market maker order is older one in pair.
        market_maker = [trade.ask, trade.bid].min_by(&:id)

        # Don't return fees if orders isn't market_maker.
        return nil if order != market_maker

        # Return fees paid for this trade.
        executed_amount = order === OrderBid ? trade.funds : trade.volume
        Fee.new\
          parent: order,
          source_account: Fee::PLATFORM_ACCOUNT_ID,
          target_account: order.hold_account,
          amount:         executed_amount * 0.001
      end

      def on_cancel(order)
        Fee.new\
          parent:         order,
          source_account: Fee::PLATFORM_ACCOUNT_ID,
          target_account: order.hold_account,
          amount:         order.locked * 0.001
      end
    end
  end
end
