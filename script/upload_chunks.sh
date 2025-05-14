#!/bin/bash

# Create this as script/upload_chunks.sh
CHUNK=0
IMAGE_SIZE=$(wc -c < src/1.txt)
CHUNK_SIZE=5000
TOTAL_CHUNKS=$(( ($IMAGE_SIZE + $CHUNK_SIZE - 1) / $CHUNK_SIZE ))

echo "Total chunks to process: $TOTAL_CHUNKS"

while [ $CHUNK -lt $TOTAL_CHUNKS ]; do
    echo "Processing chunk $CHUNK of $TOTAL_CHUNKS"
    
    forge script script/AddFirstImage.sol:AddFirstImage --sig "run(uint256)" $CHUNK --broadcast --fork-url https://sepolia.infura.io/v3/7c722c5d30fb4872879a308ddecf01cd
    
    if [ $? -ne 0 ]; then
        echo "Failed at chunk $CHUNK"
        exit 1
    fi
    
    echo "Chunk $CHUNK complete. Waiting 1 seconds..."
    sleep 1
    CHUNK=$((CHUNK + 1))
done

echo "All chunks processed successfully!"