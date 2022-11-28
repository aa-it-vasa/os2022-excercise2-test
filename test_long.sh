echo "Test 3 - längre texter"
echo

fail=false
numtests=9
currtest=1

allFiles=(test/1000.txt test/100000.txt test/dumas.txt)

for file in ${allFiles[@]}; do
  outfile=$file.sort
  resfile=$file.out
  output=$(./sortwords < $file)
  code=$?
  numlines=$(grep -c '^' $file)
  numwords=$(cat $file |wc -w)
  expected_output="Read $numlines rows and $numwords words"

  if [ "$output" == "$expected_output" ] ; then
    echo "[$currtest/$numtests] Ok: Rätt output från filen \"$file\". Förväntat \"$expected_output\" fick \"$output\"."
  else
    echo "[$currtest/$numtests] Fel: Fel output från filen \"$file\". Förväntat \"$expected_output\" men fick \"$output\"."
    fail=true
  fi

  currtest=$((currtest+1))
  cat $file| tr '[:upper:]' '[:lower:]' | tr '[:space:]' '[\n*]' |tr -d '1234567890()\"\047&$,.!?:[];\t' | tr -d '[:digit:]' | grep -v "^\s*$" | LC_COLLATE=C sort > $outfile
  cp output.txt $resfile
  diff -q output.txt $outfile 1>/dev/null
  code2=$?
  rm output.txt -f
  if [[ $code2 == "0" ]]
  then
    echo "[$currtest/$numtests] Ok: Rätt sorterad fil skapad från filen \"$file\". Filen \"$resfile\" har samma innehåll som filen \"$outfile\"".
  else
    echo "[$currtest/$numtests] Fel: Fel sorterad fil skapad från filen \"$file\". Filen \"$resfile\" har inte samma innehåll som filen \"$outfile\"".
    fail=true
  fi

  currtest=$((currtest+1))

done

currtest=$((currtest+1))

if grep -q alloc "sortwords.c"; then
  echo "[$currtest/$numtests] Ok: Det verkar som om du använt *alloc åtminstone en gång i ditt program."
else
  echo "[$currtest/$numtests] Fel: Det verkar som om du aldrig använt *alloc i ditt program."
  fail=true
fi

currtest=$((currtest+1))

if grep -q free "sortwords.c"; then
  echo "[$currtest/$numtests] Ok: Det verkar som om du använt free åtminstone en gång i ditt program."
else
  echo "[$currtest/$numtests] Fel: Det verkar som om du aldrig använt free i ditt program."
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