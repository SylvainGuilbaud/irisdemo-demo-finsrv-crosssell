# New transaction
export amount=$1
echo $amount

generate_post_data()
{
  cat <<EOF
{
  "TransType": "TRANSFER",
  "Amount": "${amount}",
  "FromAccountNumber": "M1353266412",
  "ToAccountNumber": "C1315400589"
}
EOF
}

curl -i -X POST \
--url http://localhost:9092/csp/appint/rest/transaction/ \
-u _system:sys \
-H 'Content-Type: application/json' \
--data "$(generate_post_data)"