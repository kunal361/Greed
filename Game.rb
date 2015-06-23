require "./Player.rb"
class Game

	def initialize(number_of_players)
		@final = false # set when game enters final round
		@breaker = -1 # equal to the player that first achieves the score 3000
		@number_of_players = number_of_players #number of players playing the game
		@players = Array.new(number_of_players) { |player| # Array storing all the player objects
			player = Player.new
		}
	end

	def score(values) #calculates the score of the imput dice values, returns the score and the number of dices that did not add to the score
		unscored = values.size
		count_values = Array.new(7) { |count_value| count_value = 0 }
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

def one_turn (player) #simulates one turn of a given player
		@players[player].roll(5)
		puts "#{@players[player].name}: #{@players[player].turn.values}"
		current_score, unscored = score(@players[player].turn.values)
		puts "Current turn score: #{current_score}"
	if unscored == 5
			puts "#{@players[player].name} scored 0 on this roll. Hence passes turn"
			return
		end
		if unscored == 0
			if current_score >= 300 && @players[player].in_play == false
				puts "#{@players[player].name} joins game!"
				@players[player].start_play
			end
			if @players[player].in_play
				@players[player].add_to_score(current_score)
			end
			puts "#{@players[player].name} passes turn"
		end

    while unscored > 0
			if @players[player].wants_to_continue
				@players[player].roll(unscored)
				puts "#{@players[player].name}: #{@players[player].turn.values}"
				new_current_score, new_unscored = score(@players[player].turn.values)
				current_score += new_current_score
				puts "Current turn score: #{current_score}"

        if new_unscored == unscored
					puts "#{@players[player].name} scored 0 on this roll. Hence passes turn"
					break
				end
				unscored = new_unscored
				if unscored == 0
					if current_score >= 300 && @players[player].in_play == false
						puts "#{@players[player].name} joins game!"
						@players[player].start_play
					end
					if @players[player].in_play
						@players[player].add_to_score(current_score)
					end
					puts "#{@players[player].name} passes turn"
				end

			elsif(@players[player].in_play)
				if current_score >= 300 && @players[player].in_play == false
					puts "#{@players[player].name} joins game!"
					@players[player].start_play
				end
				if @players[player].in_play
					@players[player].add_to_score(current_score)
				end
				puts "#{@players[player].name} passes turn"
				if !@final && @players[player].score >= 3000
					@breaker = player
					@final = true
				end
				break
			end
			if !@final && @players[player].score >= 3000
				@breaker = player
				@final = true
				break
			end
		end
	end

	def print_scores #prints scores after the latest round
		player = 0
		while player < @number_of_players
			puts  "#{@players[player].name}: #{@players[player].score}"
			player += 1
		end
	end

	def round #simulates a round
		player = 0
		while player < @number_of_players
			if player != @breaker
				one_turn player
			end
			if @final
				break
			end
			player += 1
		end
	end

	def play #simulates the game
		while true
			puts "--------------------------------\n\t New Round\n--------------------------------"
			round
			puts "--------------------------------\nScores after this round\n--------------------------------"
			print_scores
			break if @final
		end
		puts "--------------------------------\n\tFinal round\n--------------------------------"
		@final = false
		round
		puts "--------------------------------\nScores After Final round\n--------------------------------"
		print_scores
		winner = @players.max_by {|player| player.score}
		puts "--------------------------------\n\tWinner\n--------------------------------"
		puts winner.name
	end
end
