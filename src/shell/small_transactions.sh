# New transaction
while true 
do
export amount=$(( ( RANDOM % 10 )  + 1 ))
echo $amount
$PWD/src/shell/transaction.sh $amount
done