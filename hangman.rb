class Hangman
  def initialize
    puts "Welcome! Lets play Hangman!"
    #@secret_word = File.readlines('dictionary.txt', chomp: true).select {|word| word.length >= 5 && word.length <= 12}.sample
    @secret_word = 'regent'
    @secret_word_immutable = @secret_word.dup
    @secret_word_display = @secret_word.gsub(/[a-z]/, '_ ').chop.split(' ')
    @guesses = 6
    @wrong_letters_guessed = []
    @right_letters_guessed = []
  end

  def display
    puts "\nYou have #{@guesses} guesses left!"
    puts "\n#{@secret_word_display.join(' ')}"
    puts "\nIncorrect letters already guessed: #{@wrong_letters_guessed.join(', ')}" if @wrong_letters_guessed != []
  end

  def guess_letter
    begin
      puts "Guess a letter!"
      letter = gets.chomp.downcase
      raise 'Error' if letter.length != 1 || @wrong_letters_guessed.include?(letter) || @right_letters_guessed.include?(letter) || !letter.match?(/\A[a-z]\z/)
    rescue 
      puts "Make sure you only enter 1 letter and that you haven't already guessed that letter." 
      retry
    else
      if @secret_word.include?(letter)
        @right_letters_guessed.push(letter)
        @secret_word.split('').each do |element|
            if element == letter
              letter_index = @secret_word.index(letter) #find index of match
              @secret_word[@secret_word.index(letter)] = '-' #mutate secret word
              @secret_word_display[letter_index] = letter #change display
            end
          end
      else
        @wrong_letters_guessed.push(letter)
      end
      @guesses -= 1
    end
  end

  def play_game
    while @guesses != 0 
      if @secret_word_immutable == @secret_word_display.join
        puts "You guessed the word!"
        break
      end
      display
      guess_letter
    end
    puts "GAME OVER. The secret word was: #{@secret_word_immutable}"
  end
end

game = Hangman.new
game.play_game