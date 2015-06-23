require './DiceSet.rb'
class Player
  attr_reader :name
  attr_reader :score
  attr_reader :in_play
  attr_reader :turn
  @@count_of_players = 0 # keeps a count of the players added, used to give a unique name to each player
  def initialize
    @@count_of_players += 1
    @name = "Player #{@@count_of_players}"
    @score = 0 #players score
    @turn = DiceSet.new
    @in_play = false # set when player ends his/her turn with 300 or more points the first time
  end
  def wants_to_continue # returns true if player wants to continue else false
    rand(2) == 1
  end
  def start_play #sets the in_play variable
    @in_play = true
  end
  def add_to_score(current_score) # adds the current rounds score to the player's score
    @score += current_score
  end
  def roll(number_of_dice)
    @turn.roll(number_of_dice)
  end
end
