#!/bin/bash
echo Enter your API key:
read API_KEY

rm -r ./Sources/NatParkSwiftKit/Data
mkdir ./Sources/NatParkSwiftKit/Data

declare -a ENDPOINTS=("parks" "visitorcenters")

for ENTITY in "${ENDPOINTS[@]}"
do
    curl -X GET "https://developer.nps.gov/api/v1/$ENTITY?limit=200&fields=images&api_key=$API_KEY " -H "accept: application/json" -o "$ENTITY.json"
	mv $ENTITY.json ./Sources/NatParkSwiftKit/Data/
done
