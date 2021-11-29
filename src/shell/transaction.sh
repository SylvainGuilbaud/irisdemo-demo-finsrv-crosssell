# New transaction
export amount=$1
echo $amount

generate_post_data()
{
  cat <<EOF
{
  "TransType": "PAYMENT",
  "Amount": "${amount}",
  "FromAccountNumber": "C1315400589",
  "ToAccountNumber": "M1353266412"
}
EOF
}

curl -i -X POST \
--url http://localhost:9092/csp/appint/rest/transaction/ \
-u _system:sys \
-H 'Content-Type: application/json' \
--data "$(generate_post_data)"

# -d '{"TransType": "PAYMENT","Amount": "7.5","FromAccountNumber": "C1315400589","ToAccountNumber": "M1353266412"}' \