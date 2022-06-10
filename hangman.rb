require 'yaml'

class Hangman
  def initialize
    puts "Welcome! Lets play Hangman!"
    @secret_word = File.readlines('dictionary.txt', chomp: true).select {|word| word.length >= 5 && word.length <= 12}.sample
    @secret_word_immutable = @secret_word.dup
    @secret_word_display = @secret_word.gsub(/[a-z]/, '_ ').chop.split(' ')
    @guesses = 6
    @end_game = 0
    @wrong_letters_guessed = []
    @right_letters_guessed = []
    puts "\nWould you like to load previously saved game? (yes or no)"
    answer = gets.chomp.downcase
    load_game if answer == 'yes'
  end

  def load_game
    yaml = YAML.load_file('saved_game.yml')
    @secret_word = yaml['secret_word']
    @secret_word_immutable = yaml['secret_word_immutable']
    @secret_word_display = yaml['secret_word_display']
    @guesses = yaml['guesses']
    @end_game = yaml['end_game']
    @wrong_letters_guessed = yaml['wrong_letters_guessed']
    @right_letters_guessed = yaml['right_letters_guessed']
    puts "\nSaved game loaded!"
  end

  private
  def display
    puts "\nYou have #{@guesses} guesses left!"
    puts "\n#{@secret_word_display.join(' ')}"
    puts "\nIncorrect letters already guessed: #{@wrong_letters_guessed.join(', ')}" if @wrong_letters_guessed != []
  end

  private
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

  private
  def guess_word
    puts "\nWould you like to guess the word? (Enter yes or no, or enter save to save the game)"
    answer = gets.chomp.downcase
    save_game if answer == 'save'
    if answer == 'yes'
        puts "\nTry to guess the word!"
        guess_word = gets.chomp.downcase
        if guess_word == @secret_word_immutable
          @end_game += 1
        end
    end
  end

  private
  def save_game
    save_hash = {
        'secret_word' => @secret_word,
        'secret_word_immutable' => @secret_word_immutable,
        'secret_word_display' => @secret_word_display,
        'guesses' => @guesses,
        'end_game' => @end_game,
        'wrong_letters_guessed' => @wrong_letters_guessed,
        'right_letters_guessed' => @right_letters_guessed
    }
    File.open('saved_game.yml', 'w') { |f| YAML.dump(save_hash, f) }
    puts 'Game Saved!'
  end

  public
  def play_game
    loop do
      if @end_game != 0 || @guesses == 0 || @secret_word_immutable == @secret_word_display.join
        break
      end
      display
      guess_word
      guess_letter
    end
    puts "GAME OVER. The secret word was: #{@secret_word_immutable}"
  end
end

game = Hangman.new
game.play_game