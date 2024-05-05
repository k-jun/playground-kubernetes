for i in 102 202; do
  ssh 192.168.11.12 qm shutdown $i
  ssh 192.168.11.12 qm destroy $i
done

for i in 103 203; do
  ssh 192.168.11.13 qm shutdown $i
  ssh 192.168.11.13 qm destroy $i
done

for i in 101 201 9002 9001; do
  qm shutdown $i
  qm destroy $i
done

