# THIS WILL BE MOVED TO PEATIO-CORE.
# binding.pry
# require 'peatio'

module Peatio
  class FeeService

    OPERATIONS = %i[order withdraw].freeze
    ACTIONS    = %i[on_submit on_complete on_cancel].freeze

    class << self
      ACTIONS.each do |action|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{action}(operation_type, *args)
            run_middlewares(:#{action}, operation_type, *args)
          end
        RUBY
      end

      OPERATIONS.each do |operation|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{operation}_middlewares
            variable_name = "@#{operation}_middlewares"
            instance_variable_get(variable_name) ||\
            instance_variable_set(variable_name, [])
          end

          def #{operation}_middlewares=(list)
            instance_variable_set("@#{operation}_middlewares", list)
          end
        RUBY
      end

      def run_middlewares(action, operation_type, *args)
        raise Error, 'Unsupported operation for FeeService.' unless operation_type.to_sym.in? OPERATIONS

        middlewares = method("#{operation_type}_middlewares").call
        middlewares
          .each_with_object([]) do |middleware, fees|
            fees.concat middleware
                          .public_send(action, *args)
                          .yield_self { |fee| Array(fee) }
          end
          .compact
          .yield_self { |fees| FeeService.new(fees) }
      rescue StandardError => e
        raise Error, e.message
      end
    end

    attr_accessor :fees

    def initialize(fees)
      @fees = Array(fees)
    end

    def submit!
      ActiveRecord::Base.transaction do
        fees.each do |fee|
          fee.source_account&.lock_funds!(fee.amount)
        end
      end
    end

    def complete!
      ActiveRecord::Base.transaction do
        fees.each do |fee|
          fee.source_account&.unlock_and_sub_funds!(fee.amount)
          fee.target_account&.plus_funds!(fee.amount)
        end
      end
    end
  end
end
