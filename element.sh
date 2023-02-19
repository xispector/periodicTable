#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  ELEMENT_DATA=""
  ELEMENT_SELECT () {
      ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE $1 = $2")
  }
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_SELECT "atomic_number" "$1"
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    ELEMENT_SELECT "symbol" "'$1'"
  else
    ELEMENT_SELECT "name" "'$1'"
  fi

  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database." 
  else
    echo $ELEMENT_DATA | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi