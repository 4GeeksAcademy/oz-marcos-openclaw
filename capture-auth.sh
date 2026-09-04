#!/bin/bash
# Run mcporter auth and capture the auth URL + port immediately
npx -y mcporter auth zapier --no-browser 2>&1 | tee /tmp/mcporter-out.txt &
MCPID=$!

# Wait for the auth URL to appear in output
for i in $(seq 1 15); do
  sleep 1
  if grep -q "mcp.zapier.com/oauth" /tmp/mcporter-out.txt 2>/dev/null; then
    URL=$(grep -oP 'https://mcp\.zapier\.com[^ ]+' /tmp/mcporter-out.txt | head -1)
    PORT=$(grep -oP '127\.0\.0\.1:\K[0-9]+' /tmp/mcporter-out.txt | head -1)
    echo "=== AUTH_URL: $URL"
    echo "=== CALLBACK_PORT: $PORT"
    break
  fi
done

wait $MCPID