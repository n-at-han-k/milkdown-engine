# frozen_string_literal: true

require "test_helper"

class MilkdownEngineTest < Minitest::Test
  def test_version
    refute_nil MilkdownEngine::VERSION
  end
end
