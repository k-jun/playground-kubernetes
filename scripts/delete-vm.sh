for i in 101 102 103 201 202 203 9002 9001; do
  qm shutdown $i
  qm destroy $i
done
