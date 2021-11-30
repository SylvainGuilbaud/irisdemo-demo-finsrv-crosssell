# enable/disable AWS SNS and Send Email operations
export enable=$1
echo $enable

curl -X GET \
--url http://localhost:9092/csp/appint/rest/sns/${enable} \
-u _system:sys 