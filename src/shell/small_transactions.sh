# deactivate AWS SNS operation
$PWD/src/shell/shs.sh 0
# loop of transactions
while true 
do
export amount=$(( ( RANDOM % 10 )  + 1 ))
echo $amount
$PWD/src/shell/transaction.sh $amount
done