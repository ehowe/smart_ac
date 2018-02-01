module Apiable
  extend ActiveSupport::Concern

  included do
    before_create :set_api_key
  end

  def set_api_key
    self.api_key ||= SecureRandom.hex(16)
  end
end
