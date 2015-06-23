class DiceSet
	attr_reader :values
	def roll(number_of_dice)
		@values = Array.new(number_of_dice) { |x| # contains random values of the rolled dices which are 'number_of_dice' in number
			x = rand(6) + 1
		}
	end
end
