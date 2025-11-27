#!/bin/bash

echo "=== Health monitor ==="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "1. Checking app's health..."
HEALTH=$(curl -s http://localhost:8080/health)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}App is healthy!${NC}"
    echo "$HEALTH" | python3 -m json.tool
else
    echo -e "${RED}App is not answering!${NC}"
    exit 1
fi

echo ""
echo "2. App metrics..."
METRICS=$(curl -s http://localhost:8080/metrics)
echo "$METRICS" | python3 -m json.tool

echo ""
echo "3. Verifying success rate..."
SUCCESS_RATE=$(echo "$METRICS" | python3 -c "import sys, json; data = print(json.load(sys.stdin)['success_rate_percent'])")

if (( $(echo "$SUCCESS_RATE >= 95.0" | bc -l) )); then
    echo -e "${GREEN}Success rate: $SUCCESS_RATE% (OK)${NC}"
else
    echo -e "${RED}Success rate: $SUCCESS_RATE% (LOW)${NC}"
fi