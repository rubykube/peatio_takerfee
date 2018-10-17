module Peatio
  class FeeService::Withdraw
    #
    # Calculates and returns fees which will be saved and submitted on withdraw submit.
    #
    # @abstract Derived Services must implement it.
    #
    # @param withdraw [Withdraw]
    # @return [Fee, [Fee], nil]
    #   Fee instance, fee instances array or nil.
    def on_submit(withdraw)
      method_not_implemented
    end

    #
    # Calculates and returns fees which will be append to parent withdrawal.
    # This fees will be submitted and completed automatically on withdraw complete.
    #
    # @abstract Derived Services must implement it.
    #
    # @param withdraw [Withdraw]
    # @return [Fee, [Fee], nil]
    #   Fee instance, fee instances array or nil.
    def on_complete(withdraw)
      method_not_implemented
    end

    #
    # Calculates and returns fees which will be append to parent withdrawal.
    # This fees will be submitted and completed automatically on withdraw cancel.
    #
    # @abstract Derived Services must implement it.
    #
    # @param withdraw [Withdraw]
    # @return [Fee, [Fee], nil]
    #   Fee instance, fee instances array or nil.
    def on_cancel(withdraw)
      method_not_implemented
    end
  end
end
