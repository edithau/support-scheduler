require 'test_helper'

class HeroTest < ActiveSupport::TestCase
  test "should have unique names" do
    hero = heros(:Sherry)
    dup_hero = Hero.create(name: 'Sherry')
    assert hero.valid?
    assert dup_hero.invalid?
  end
end
