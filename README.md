# FARMER SONIC

## Overview

FARMER SONIC is a DeFi project that allows users to hold FARM tokens and earn SONIC rewards on every trade. The project operates on a simple principle: hold more than 100 FARM tokens and automatically earn $SONIC rewards.

**Website**: [https://farmersonic.xyz/](https://farmersonic.xyz/)  
**Twitter**: [@FarmerSonic](https://twitter.com/FarmerSonic)

## Key Features

- **Hold & Earn**: Hold FARM tokens and earn SONIC rewards automatically
- **Equal Distribution**: Fair distribution of SONIC rewards to all eligible holders
- **Automatic Liquidity**: A portion of each transaction is used to add liquidity
- **Holder Rewards**: Airdrop system that rewards token holders

## Tokenomics

- **Token Name**: FARMER
- **Token Symbol**: FARM
- **Total Supply**: 1,000,000 FARM
- **Minimum Holding**: 100 FARM to qualify for rewards

### Tax Structure

- **Total Tax**: 5% on sells
  - 2.5% for Liquidity
  - 2.5% for Holder Airdrops

## Smart Contracts

This repository contains the smart contracts for the FARMER SONIC project:

1. **FARMER.sol**: The main ERC20 token contract with tax, liquidity, and airdrop functionality
2. **SwapProxy.sol**: Helper contract for handling token swaps and ETH transfers

## Technical Details

The FARMER token implements several key mechanisms:

- **Holder Tracking**: Automatically tracks addresses holding the minimum required amount
- **Automatic Processing**: Accumulated taxes are processed into liquidity and airdrops
- **Reward Distribution**: ETH rewards are distributed to all qualifying holders
- **Liquidity Generation**: Automatic liquidity addition to strengthen the token's market

## Security Features

- **Reentrancy Protection**: Guards against reentrancy attacks
- **Owner Controls**: Limited owner functions for necessary adjustments
- **Slippage Protection**: Prevents excessive slippage during swaps
- **Proxy Architecture**: Secure swap proxy for handling ETH transfers

## Getting Started

To participate in the FARMER SONIC ecosystem:

1. Purchase FARM tokens on the Metropolis DEX
2. Hold at least 100 FARM tokens in your wallet
3. Automatically receive SONIC rewards on every trade
4. No staking or claiming required - rewards are sent directly to your wallet

## Development

The smart contracts are written in Solidity ^0.8.17 & 0.8.20 and are designed to work with the Metropolis DEX.


## Disclaimer

This project is provided as-is without any guarantees or warranties. Users should do their own research before interacting with any smart contracts.

---

**FARM and EARN SONIC - This is a free farm. Equal Sonic for everyone!** 
