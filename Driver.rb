require "./Game.rb"
def main
  print "Enter number of players: "
  number_of_players = gets.chomp.to_i
  while number_of_players == 0
    print "Enter a valid number of players: "
    number_of_players = gets.chomp.to_i
  end
  game = Game.new(number_of_players)
  puts "--------------------------------\n\tStarting game\n--------------------------------"
  game.play
  puts "--------------------------------\n\tGame Over\n--------------------------------"
end

main
