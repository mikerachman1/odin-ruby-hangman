class Hangman
  def initialize
    @secret_word = File.readlines('dictionary.txt', chomp: true).select {|word| word.length >= 5 && word.length <= 12}.sample
    p @secret_word
  end
end

game = Hangman.new