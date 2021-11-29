# New transaction
while true 
do
export amount=$(( ( RANDOM % 10 )  + 1 ))
echo $amount
./transaction.sh $amount
done