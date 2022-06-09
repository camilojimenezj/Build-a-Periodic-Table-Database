#! /bin/bash
# Element Properties 

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if there's an argument
if [[ -z $1 ]]
then
  echo Please provide an element as an argument. 
  exit
fi
# Check if the argument is a symbol or a name from the table
SELECT_RESULT=$($PSQL "SELECT * FROM elements WHERE (symbol='$1') OR (name='$1')")

# if select_result is empty
if [[ -z $SELECT_RESULT ]]
then
  # check if is an atomic number from the table 
  SELECT_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
fi

# if is still empty 
if [[ -z $SELECT_RESULT ]]
then
echo I could not find that element in the database.
else 
  echo $SELECT_RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
  do
    # get type
    TYPE=$($PSQL "SELECT type FROM properties JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    # get mass 
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    # get melting point 
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    # get boiling point 
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    # echo output
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $(echo $TYPE | sed 's/^ *| *$//g'), with a mass of $(echo $MASS | sed 's/^ *| *$//g') amu. $NAME has a melting point of $(echo $MELTING | sed 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING | sed 's/^ *| *$//g') celsius."
  done
fi


 

