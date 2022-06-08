class Hangman
  def initialize
    puts "Welcome! Lets play Hangman!"
    @secret_word = File.readlines('dictionary.txt', chomp: true).select {|word| word.length >= 5 && word.length <= 12}.sample
    # p @secret_word
    @secret_word_display = @secret_word.gsub(/[a-z]/, '_ ').chop
    # p @secret_word_display
    @guesses = 6
    @wrong_letters_guessed = []
    @right_letters_guessed = []
  end

  def display
    puts "\nYou have #{@guesses} guesses left!"
    puts "\n#{@secret_word_display}"
    puts "\nIncorrect letters already guessed: #{@wrong_letters_guessed}" if @wrong_letters_guessed != []
  end
end

game = Hangman.new
game.display