#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~My Salon~~"
echo -e "\nWelcome, how I can help you?"

MAIN_MENU(){

if [[ $1 ]]
then
  echo -e "\n$1"
fi
echo -e "\n1) Cut\n2) Color\n3) Perm"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
1) FIND_CUSTOMER $SERVICE_ID_SELECTED;;
2) FIND_CUSTOMER $SERVICE_ID_SELECTED;;
3) FIND_CUSTOMER $SERVICE_ID_SELECTED;;
*) MAIN_MENU "I could not find that service. What would you like today?";;
esac

}

FIND_CUSTOMER(){
 SERVICE_ID_SELECT=$1
 echo -e "What's your phone number?"
 read CUSTOMER_PHONE
 CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
 if [[ -z $CUSTOMER_ID ]]
 then
    echo -e "\nWe dont have any customer with that phone number. What's your name"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
 fi
 CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
 SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
 CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
 echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
 read SERVICE_TIME
 INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
 echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}


MAIN_MENU