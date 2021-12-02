# Add account to the whitelist

generate_post_data()
{
  cat <<EOF
{
  "FromAccountNumber": "C1315400589",
  "FromDate": "2021-12-01",
  "ToDate": "2021-12-31"
}
EOF
}

curl -i -X POST \
--url http://localhost:9092/csp/appint/rest/whitelist/ \
-u _system:sys \
-H 'Content-Type: application/json' \
--data "$(generate_post_data)"