# Ethereum 2.0 Staking with Kubernetes

## Geth with Kubernetes
From: https://messari.io/article/running-an-ethereum-node-on-kubernetes-is-easy

## Lighthouse with Kubernetes

### Validator Keys
```
docker run -it -v /Users/mikeghen/Documents/Projects/tellorpool_org/eth2/:/root/.lighthouse/ sigp/lighthouse lighthouse --network pyrmont account validator import --directory /root/.lighthouse/pyrmont/validators/validator_keys
```
