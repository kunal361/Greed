class DiceSet
  
  attr_reader :values
  
  def roll(number_of_dice)
    @values = Array.new # contains random values of the rolled dices which are 'number_of_dice' in number
    @values = number_of_dice.times.map do
      rand(6) + 1
    end
  end

end