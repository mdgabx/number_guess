#!/bin/bash

echo -e "\n~~ Number Guess ~~\n"

# connecting the database
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"

# randomly generate number from 1 to 1000

N=$(( RANDOM % 1000 )) # secret number


echo -e "\nEnter your username:"
read USERNAME

VIEW_USER=$($PSQL "SELECT * FROM players WHERE username='$USERNAME';")

if [[ -z $VIEW_USER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  # insert the player username
  INSERT_USERNAME=$($PSQL "INSERT INTO players(username, games_played, best_game) VALUES('$USERNAME', 1, 0);")

else 
  echo "existing user"
fi
