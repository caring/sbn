require 'test/unit'
require File.dirname(__FILE__) + '/../lib/sbn4r'

class NetTest < Test::Unit::TestCase
  def setup
  end
  
  def teardown
  end
  
  def test_mcmc_inference
    net       = Sbn::Net.new("Grass Wetness Belief Net")
    cloudy    = Sbn::Node.new(:cloudy, [:true, :false], [0.5, 0.5])
    sprinkler = Sbn::Node.new(:sprinkler, [:true, :false], [0.1, 0.9, 0.5, 0.5])
    rain      = Sbn::Node.new(:rain, [:true, :false], [0.8, 0.2, 0.2, 0.8])
    grass_wet = Sbn::Node.new(:grass_wet, [:true, :false], [0.99, 0.9, 0.9, 0.0, 0.01, 0.1, 0.1, 1.0])
    net << [cloudy, sprinkler, rain, grass_wet]
    cloudy.add_child(sprinkler)
    cloudy.add_child(rain)
    sprinkler.add_child(grass_wet)
    rain.add_child(grass_wet)
    
    net.set_evidence :sprinkler => :false, :rain => :true
    probs = net.query_node(:grass_wet)
    assert (probs[:true] * 10).round == 9.0
    assert (probs[:false] * 10).round == 1.0
  end
end