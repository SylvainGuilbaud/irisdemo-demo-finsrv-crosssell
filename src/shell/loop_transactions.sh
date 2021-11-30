# deactivate AWS SNS and Send Email operations
$PWD/src/shell/enable.sh 0
# loop of transactions
while true 
do
export amount=$(( ( RANDOM % 10 )  + 1 ))
echo $amount
$PWD/src/shell/transaction.sh $amount
done