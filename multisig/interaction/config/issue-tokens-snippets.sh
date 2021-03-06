ESDT_ISSUE_COST=50000000000000000

issueUniversalToken() {
    CHECK_VARIABLES ESDT_SYSTEM_SC_ADDRESS ESDT_ISSUE_COST UNIVERSAL_TOKEN_DISPLAY_NAME \
    UNIVERSAL_TOKEN_TICKER NR_DECIMALS

    erdpy --verbose contract call ${ESDT_SYSTEM_SC_ADDRESS} --recall-nonce --pem=${ALICE} \
    --gas-limit=60000000 --value=${ESDT_ISSUE_COST} --function="issue" \
    --arguments str:${UNIVERSAL_TOKEN_DISPLAY_NAME} str:${UNIVERSAL_TOKEN_TICKER} \
    0 ${NR_DECIMALS} str:canAddSpecialRoles str:true \
    --send --proxy=${PROXY} --chain=${CHAIN_ID}
}

issueChainSpecificToken() {
    CHECK_VARIABLES ESDT_SYSTEM_SC_ADDRESS ESDT_ISSUE_COST CHAIN_SPECIFIC_TOKEN_DISPLAY_NAME \
    CHAIN_SPECIFIC_TOKEN_TICKER NR_DECIMALS UNIVERSAL_TOKENS_ALREADY_MINTED
    
    VALUE_TO_MINT=$(echo "$UNIVERSAL_TOKENS_ALREADY_MINTED*10^$NR_DECIMALS" | bc)

    erdpy --verbose contract call ${ESDT_SYSTEM_SC_ADDRESS} --recall-nonce --pem=${ALICE} \
    --gas-limit=60000000 --value=${ESDT_ISSUE_COST} --function="issue" \
    --arguments str:${CHAIN_SPECIFIC_TOKEN_DISPLAY_NAME} str:${CHAIN_SPECIFIC_TOKEN_TICKER} \
    ${VALUE_TO_MINT} ${NR_DECIMALS} str:canAddSpecialRoles str:true \
    --send --proxy=${PROXY} --chain=${CHAIN_ID}
}

transferToSC() {
    CHECK_VARIABLES BRIDGED_TOKENS_WRAPPER CHAIN_SPECIFIC_TOKEN

    VALUE_TO_MINT=$(echo "$UNIVERSAL_TOKENS_ALREADY_MINTED*10^$NR_DECIMALS" | bc)

    erdpy --verbose contract call ${BRIDGED_TOKENS_WRAPPER} --recall-nonce --pem=${ALICE} \
    --gas-limit=5000000 --function="ESDTTransfer" \
    --arguments str:${CHAIN_SPECIFIC_TOKEN} ${VALUE_TO_MINT} str:depositLiquidity \
    --send --proxy=${PROXY} --chain=${CHAIN_ID}
}