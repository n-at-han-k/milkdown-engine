# frozen_string_literal: true

module MilkdownEngine
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
