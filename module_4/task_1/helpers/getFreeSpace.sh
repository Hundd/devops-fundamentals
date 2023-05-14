df / | awk 'NR==2 {print $5}' | tr -d -c 0-9
