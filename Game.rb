require "./Player.rb"
class Game

  def initialize(number_of_players)
    
    if(number_of_players.class != Fixnum)
      raise ArgumentError, "Integer required"
    end
    if(number_of_players < 2)
      raise "NotSufficientPlayersError: minimum 2 players required"
    end
    
    @final = false # set when game enters final round
    @breaker = -1 # equal to the player that first achieves the score 3000
    @number_of_players = number_of_players #number of players playing the game
    @players = Array.new # Array storing all the player objects
    number_of_players.times do
      @players << Player.new
    end
  end

  def score(values) #calculates the score of the imput dice values, returns the score and the number of dices that did not add to the score
    unscored = values.size
    count_values = Array.new(7,0)
    dice = 0
    while dice < values.size
      count_values[ values[dice] ] += 1
      dice += 1
    end
    current_score = 0
    value = 1
    while value < 7
      if count_values[value] >= 3
        unscored -= 3
        count_values[value] -= 3
        current_score = value == 1 ? 1000 : 100 * value
      end
      value += 1
    end
    unscored -= count_values[1] + count_values[5]
    current_score += count_values[1] * 100 + count_values[5] * 50
    [current_score, unscored]
  end

  def print_scores #prints scores after the latest round
    puts "--------------------------------\nScores after this round\n--------------------------------"
    player = 0
    while player < @number_of_players
      puts  "#{@players[player].name}: #{@players[player].score}"
      player += 1
    end
  end

  def one_turn (player, unscored) #simulates one turn of a given player
    
    @players[player].roll(unscored)
    puts "#{@players[player].name}: #{@players[player].turn.values}"
    current_score, new_unscored = score(@players[player].turn.values)
    puts "Current roll score: #{current_score}"
    if current_score == 0
      return 0
    elsif new_unscored > 0 && @players[player].wants_to_continue
      returned_score = one_turn(player, new_unscored)
      current_score += returned_score
      if returned_score == 0
        return 0
      end
    end
    current_score

  end

  def round #simulates a round
    puts "--------------------------------\n\t New Round\n--------------------------------"
    player = 0
    while player < @number_of_players
      if player != @breaker
        current_score = one_turn(player, 5)
        puts  "#{@players[player].name} scored #{current_score} in this round!"
        if current_score == 0
          puts "#{@players[player].name} scores 0, hence passes turn."
        elsif @players[player].in_play
          @players[player].add_to_score(current_score)
          puts "#{@players[player].name} passes turn."
        elsif current_score < 300
          puts "#{@players[player].name} passes turn."
        end
        if !@players[player].in_play && current_score >= 300
          puts "#{@players[player].name} joins game"
          puts "#{@players[player].name} passes turn."
          @players[player].start_play
          @players[player].add_to_score(current_score)
        end
        if @players[player].score >= 3000
          @final = true
          @breaker = player
          break
        end
      end
      if @final
        break
      end
      player += 1
    end
  end

  def play #simulates the game
    while true
      round
      print_scores
      break if @final
    end
    puts "--------------------------------\nFinal round starts!!!\n--------------------------------"
    @final = false
    round
    print_scores

    winner = @players.max_by {|player| player.score}
    winners = @players.select{|player| player.score == winner.score}
    puts "--------------------------------\n\tWinner(s)\n--------------------------------"
    winners.each do |player|
      puts player.name
    end
  end

end
