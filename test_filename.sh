echo "Test 2 - filnamn som input"
echo

fail=false
numtests=1
currtest=1

touch empty.txt
output=$(./sortwords empty.txt)
code=$?
expected_output="Read 0 rows and 0 words"
rm empty.txt
rm output.txt -f

if [ "$output" == "$expected_output" ] ; then
  echo "[$currtest/$numtests] Ok: Rätt output då input-filnamnet gavs som parameter till programmet. Förväntat \"$expected_output\" fick \"$output\"."
else
  echo "[$currtest/$numtests] Fel: Fel output då input-filnamnet gavs som parameter till programmet. Förväntat \"$expected_output\" men fick \"$output\"."
  fail=true
fi


echo

if [ "$fail" = true ]; then
  echo "Misslyckades med något av testen!"
  exit 1
else
  echo "Klarade alla test!"
  exit 0
fi