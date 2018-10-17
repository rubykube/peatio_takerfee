module Peatio
  # Error repesent all errors that can be returned from FeesService class.
  class FeeService::Error < Peatio::Error
    def initialize(ex = nil)
      # TODO: Change code.
      super code: 1000,
            text: "FeesService failed".tap { |t| t << ": #{ex}" if ex.present? }
    end
  end
end