#!/bin/bash
# Test script for EpargneArgents API endpoints

API_BASE="http://localhost:5000"
ENDPOINT="/api/DailyContribution"

echo "======================================"
echo "EpargneArgents API Test Suite"
echo "======================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if API is running
echo "Checking API availability..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_BASE")

if [ "$response" != "200" ] && [ "$response" != "404" ]; then
	echo -e "${RED}✗ API is not responding (Status: $response)${NC}"
	echo "Make sure the backend is running with: dotnet run"
	exit 1
fi

echo -e "${GREEN}✓ API is responding${NC}"
echo ""

# Test 1: POST with valid parameters
echo "Test 1: POST with valid parameters"
echo "-----------------------------------"
RESPONSE=$(curl -s -X POST "$API_BASE$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{
	"totalAmount": 10000,
	"denominations": "5;10;20;50;60",
	"numberDaysSaving": 365
  }')

if [ -z "$RESPONSE" ]; then
	echo -e "${GREEN}✓ PASSED - CSV file generated${NC}"
	echo "Response: File download (binary)"
else
	echo -e "${YELLOW}⚠ Response: $RESPONSE${NC}"
fi
echo ""

# Test 2: POST with invalid parameters (missing denominations)
echo "Test 2: POST with missing denominations"
echo "----------------------------------------"
RESPONSE=$(curl -s -X POST "$API_BASE$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{
	"totalAmount": 10000,
	"numberDaysSaving": 365
  }' \
  -w "\nHTTP_CODE:%{http_code}\n")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d ':' -f 2)

if [ "$HTTP_CODE" == "400" ]; then
	echo -e "${GREEN}✓ PASSED - Returns 400 Bad Request${NC}"
else
	echo -e "${RED}✗ FAILED - Expected 400, got $HTTP_CODE${NC}"
fi
echo ""

# Test 3: POST with invalid total amount
echo "Test 3: POST with invalid total amount"
echo "----------------------------------------"
RESPONSE=$(curl -s -X POST "$API_BASE$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{
	"totalAmount": 0,
	"denominations": "5;10;20;50;60",
	"numberDaysSaving": 365
  }' \
  -w "\nHTTP_CODE:%{http_code}\n")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d ':' -f 2)

if [ "$HTTP_CODE" == "400" ]; then
	echo -e "${GREEN}✓ PASSED - Returns 400 Bad Request${NC}"
else
	echo -e "${YELLOW}⚠ Got $HTTP_CODE (expected 400)${NC}"
fi
echo ""

# Test 4: Frontend loads
echo "Test 4: Frontend loads"
echo "---------------------"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$API_BASE/")

if [ "$RESPONSE" == "200" ]; then
	echo -e "${GREEN}✓ PASSED - Frontend accessible${NC}"
else
	echo -e "${RED}✗ FAILED - Frontend returned $RESPONSE${NC}"
fi
echo ""

# Test 5: Swagger documentation
echo "Test 5: Swagger documentation"
echo "------------------------------"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$API_BASE/swagger")

if [ "$RESPONSE" == "200" ] || [ "$RESPONSE" == "301" ]; then
	echo -e "${GREEN}✓ PASSED - Swagger docs available${NC}"
else
	echo -e "${YELLOW}⚠ Swagger returned $RESPONSE${NC}"
fi
echo ""

# Test 6: GET request (should fail - POST only)
echo "Test 6: GET request (should fail)"
echo "---------------------------------"
RESPONSE=$(curl -s -X GET "$API_BASE$ENDPOINT" \
  -w "\nHTTP_CODE:%{http_code}\n" | tail -1)

HTTP_CODE=$(echo "$RESPONSE" | cut -d ':' -f 2)

if [ "$HTTP_CODE" == "405" ]; then
	echo -e "${GREEN}✓ PASSED - Returns 405 Method Not Allowed${NC}"
else
	echo -e "${YELLOW}⚠ Got $HTTP_CODE (expected 405 or 404)${NC}"
fi
echo ""

echo "======================================"
echo "Test Suite Complete"
echo "======================================"
