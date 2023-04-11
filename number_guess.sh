#!/bin/bash

echo -e "\n~~ Number Guess ~~\n"

# connecting the database
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"

# randomly generate number from 1 to 1000

N=$(( RANDOM % 1000 )) # secret number
echo $N


echo "Enter your username:"
read USERNAME

GAME_LOGIC() {
  while true;
  do
    (( COUNTER++ ))
    if (( $GUESS > $N )) 
    then 
      echo -e "\nIt's lower than that, guess again:"
    elif (( $GUESS < $N ))
    then
      echo -e "\nIt's higher than that, guess again: "
    else 
      echo -e "\nYou guessed it in $COUNTER tries. The secret number was $N. Nice job!" 
      break
    fi

    read GUESS
  done

  # update player stats
  UPDATE_STATS=$($PSQL "UPDATE players SET games_played=games_played+1, best_game=LEAST(best_game, $COUNTER) WHERE username='$USERNAME';")

}



VIEW_USER=$($PSQL "SELECT username, games_played, best_game FROM players WHERE username='$USERNAME';")

COUNTER=0

if [[ -z $VIEW_USER ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."

  # insert the player username
  INSERT_USERNAME=$($PSQL "INSERT INTO players(username, games_played) VALUES('$USERNAME' , 0);")

  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS

  GAME_LOGIC

else 
  
  echo "$VIEW_USER" | while IFS='|' read -r USERNAME GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done

  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS

  GAME_LOGIC

 
fi

