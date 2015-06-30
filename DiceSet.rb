class DiceSet
  
  attr_reader :values
  
  def roll(number_of_dice)
    @values = Array.new # contains random values of the rolled dices which are 'number_of_dice' in number
    number_of_dice.times do
      @values << rand(6) + 1
    end
  end

end