bash

#!/bin/bash



# Check memory usage

free_output=$(free -m)

total_mem=$(echo "$free_output" | awk '/Mem:/ {print $2}')

used_mem=$(echo "$free_output" | awk '/Mem:/ {print $3}')

free_mem=$(echo "$free_output" | awk '/Mem:/ {print $4}')

mem_usage=$(echo "scale=2; $used_mem/$total_mem*100" | bc)

if (( $(echo "$mem_usage > 90" | bc -l) )); then

  echo "Memory usage is high ($mem_usage%)."

fi



# Check disk usage

df_output=$(df -h)

disk_usage=$(echo "$df_output" | awk '/\/$/ {print $5}' | sed 's/%//')

if (( disk_usage > 90 )); then

  echo "Disk usage is high ($disk_usage%)."

fi



# Check CPU usage

top_output=$(top -bn1)

cpu_usage=$(echo "$top_output" | awk '/^%Cpu/ {print $2}')

if (( $(echo "$cpu_usage > 90" | bc -l) )); then

  echo "CPU usage is high ($cpu_usage%)."

fi