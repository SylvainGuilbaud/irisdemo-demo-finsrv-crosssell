# New transaction
curl -i -X POST \
--url http://localhost:9092/csp/appint/rest/transaction/ \
-u _system:sys \
-H 'Content-Type: application/json' \
-d '{"TransType": "PAYMENT","Amount": "7.5","FromAccountNumber": "C1315400589","ToAccountNumber": "M1353266412"}'
