#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUM=$((1 + $RANDOM % 1000))
ATTEMPTS=0

GAME(){
echo "Guess the secret number between 1 and 1000:"
while true
do 
  read NUM
  ((ATTEMPTS++))
  if [[ ! $NUM =~ ^[0-9]+$ ]]
  then 
  echo "That is not an integer, guess again:"
  else
    if [[ $NUM -lt $SECRET_NUM ]]
    then
    echo "It's higher than that, guess again:"
    elif [[ $NUM -gt $SECRET_NUM ]]
    then
    echo "It's lower than that, guess again:"
    else
    if [[ $ATTEMPTS -lt $B_G ]]
    then
    UPDATE_BEST=$($PSQL "UPDATE games SET best_game=$ATTEMPTS WHERE username='$USERNAME'")
    fi 
    echo "You guessed it in $ATTEMPTS tries. The secret number was $SECRET_NUM. Nice job!"
    exit
    fi
  fi
done
}

echo "Enter your username:"
read USERNAME
VALID_MEMBER=$($PSQL "SELECT username FROM games WHERE username='$USERNAME'")
if [[ -z $VALID_MEMBER ]]
then
B_G=1000
NEW_MEMBER=$($PSQL "INSERT INTO games(username, games_played, best_game) VALUES('$USERNAME', 1, 1000)")
echo  -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
GAMES_PLAYED=$($PSQL "SELECT games_played FROM games WHERE username='$USERNAME'")
B_G=$($PSQL "SELECT best_game FROM games WHERE username='$USERNAME'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $B_G guesses."
((GAMES_PLAYED++))
UPDATE=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
fi

GAME


