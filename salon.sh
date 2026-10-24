#!/bin/bash

PSQL="psql -X -U freecodecamp -d salon -qtA"

sql_escape() {
  printf "%s" "$1" | sed "s/'/''/g"
}

echo "~~~~~ MY SALON ~~~~~"
echo
printf "Welcome to My Salon, how can I help you?\n\n"

while true; do
  SERVICE_OPTIONS=$($PSQL -c "SELECT service_id || ') ' || name FROM services ORDER BY service_id;")
  printf '%s\n' "$SERVICE_OPTIONS"
  read SERVICE_ID_SELECTED

  if [[ "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]] && $PSQL -c "SELECT 1 FROM services WHERE service_id = $SERVICE_ID_SELECTED;" | grep -q "1"; then
    break
  fi

  printf '%s\n%s\n' "I could not find that service. What would you like today?" "$SERVICE_OPTIONS"
done

SERVICE_NAME=$($PSQL -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
printf '%s\n' "What's your phone number?"
read CUSTOMER_PHONE

while true; do
  CUSTOMER_NAME=$($PSQL -c "SELECT name FROM customers WHERE phone = '$(sql_escape "$CUSTOMER_PHONE")';")

  if [[ -n "$CUSTOMER_NAME" ]]; then
    break
  fi

  printf '%s\n' "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  $PSQL -c "INSERT INTO customers (phone, name) VALUES ('$(sql_escape "$CUSTOMER_PHONE")', '$(sql_escape "$CUSTOMER_NAME")');"
done

printf '%s\n' "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL -c "SELECT customer_id FROM customers WHERE phone = '$(sql_escape "$CUSTOMER_PHONE")';")
$PSQL -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$(sql_escape "$SERVICE_TIME")');"

printf '%s\n' "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
