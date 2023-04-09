#!/bin/bash

echo -e "\n~~ Number Guess ~~\n"

# connecting the database
PSQL="psql -X --username=freecodecamp --dbname=user_db -t --no-align -c"

# randomly generate number from 1 to 1000

N=$(( RANDOM % 1000 )) # secret number


echo -e "\nEnter your username:"
read USERNAME

VIEW_USER=$($PSQL "SELECT * FROM players WHERE username='$USERNAME';")

if [[ -z $VIEW_USER ]]
then
  echo "new user"
else 
  echo "existing user"
fi
