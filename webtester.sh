#/bin/sh

if [ "$#" -ne 2 ]; then
	echo "address and number of iterations expected"
	exit
fi

TEST_ADDRESS=$1
TEST_TOTAL=$2
TTFB_ACC=0
TOTAL_ACC=0
echo "Testing Address '$1' over $TEST_TOTAL iterations"
for i in $(seq 1 $TEST_TOTAL);
do
	RESULT=$(curl -s -o /dev/null -w "%{time_connect} %{time_starttransfer} %{time_total} \n" $TEST_ADDRESS | tr ',' '.')
	TTFB=$(echo $RESULT | awk '{print $2}')
	TOTAL=$(echo $RESULT | awk '{print $3}')
	TTFB_ACC=$(echo "$TTFB_ACC+$TTFB" | bc)
	TOTAL_ACC=$(echo "$TOTAL_ACC+$TOTAL" | bc)

	#echo $TTFB
	echo "iteration $i: $TOTAL"
done
TTFB=$(echo "scale=4;$TTFB_ACC/$TEST_TOTAL" | bc)
TOTAL=$(echo "scale=4;$TOTAL_ACC/$TEST_TOTAL" | bc)
echo "TTFB: $TTFB"
echo "TOTAL: $TOTAL"
