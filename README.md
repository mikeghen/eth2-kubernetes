# Ethereum 2.0 Staking with Kubernetes of GCP

:warning: This is for Staking on Testnet and has not been tested on mainnet.

# Overview
This is a reference implementation for managing ETH2 staking on Kubernetes. This implementation uses geth as the ETH1 client and lighthouse as the ETH2 client. Use this repo for educational purposes only. Nothing here should be considered "mainnet ready," it's purely designed to be an example for running ETH2 on Kubernetes and has only been tested on testnet.

# User Guide

:warning: This is a work in progress so the user guide are pretty vague.

0. Watch this great [video from ETHOnline](https://www.youtube.com/watch?v=96UfJPYyFcs&feature=youtu.be&t=17049) about ETH2 staking from SuperFiz
1. Review [Lighthouse Book](https://lighthouse-book.sigmaprime.io/intro.html)
2. Follow the setup process on the [Pyrmont Eth2 Launchpad](https://pyrmont.launchpad.ethereum.org/), this should provide you with a `./validator_keys` directory
3. Create a directory in this repo for the pyrmont network and your validators
```
mkdir -p pyrmont/validators
```
4. Move your `validator_keys` in `pyrmont/validators`
```
mv ./validator_keys ./pyrmont/validators/
```
5. Use lighthouse with Docker to import your validators
```
docker run -it -v /path/to/eth2-kubernetes/:/root/.lighthouse/ sigp/lighthouse lighthouse --network pyrmont account validator import --directory /root/.lighthouse/pyrmont/validators/validator_keys
```
Which should look like:
```
Running account manager for pyrmont network
validator-dir path: "/root/.lighthouse/pyrmont/validators"
validator-dir path: "/root/.lighthouse/pyrmont/validators"
WARNING: DO NOT USE THE ORIGINAL KEYSTORES TO VALIDATE WITH ANOTHER CLIENT, OR YOU WILL GET SLASHED.

Keystore found at "/root/.lighthouse/pyrmont/validators/validator_keys/keystore-m_XXXXXXXXXXXXX.json":

 - Public key: 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 - UUID: XXXXXXXXXXXX

If you enter the password it will be stored as plain-text in validator_definitions.yml so that it is not required each time the validator client starts.

Enter the keystore password, or press enter to omit it:

Password is correct.

Successfully imported keystore.
Successfully updated validator_definitions.yml.
```
6. Confirm `pyrmont/validators/validator_definitions.yaml` exists and that there is a directory in `pyrmont/validators` for the validator that contains the keystore file. For example:
```
├── pyrmont
    └── validators
    |   └── 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    └── keystore-XXXXXX.json
    └── validator_definitions.yaml
```
:warning: Do not commit this directory to Github!
7. Create a new project on GCP with a unique project ID. For this example, you will see `YOUR_PROJECT_ID`, you'll replace this with the project ID you select in this step.
8. Create a Storage bucket with the name of the form: `YOUR_PROJECT_ID-lighthouse`
9. Upload the `./prymont` folder into the newly created bucket
10. Create a new Kubernetes cluster. I used a single node cluster with a standard N2 instance, 2 CPU, 8 GB memory for testing on testnet.
11. Open the **Cloud Shell Terminal** in GCP and connect to the cluster. This can also be done from your local terminal if you have `gcloud` installed.
12. Clone your eth2 repo into the terminal and go into it:
```
git clone https://github.com/your_username/eth2-kubernetes
cd eth2-kubernetes
```
13. Use `gsutil` to copy your validator folder from storage into the `lighthouse` directory in the clone repo:
```
gsutil cp -r gs://YOUR_PROJECT_ID-lighthouse/pyrmont ./lighthouse
```
14. Build the lighthouse docker image with your validator config and push into Google Container Registery:
```
docker build -t us.gcr.io/YOUR_PROJECT_ID/lighthouse:latest ./lighthouse/ --build-arg VALIDATOR_PATH=pyrmont/validators

docker push us.gcr.io/YOUR_PROJECT_ID/lighthouse:latest
```
15. Use `helm` to deploy `geth` and `lighthouse` to Kubernetes
```
helm upgrade --install --set lighthouse.image.tag=latest --set lighthouse.image.repository=us.gcr.io/YOUR_PROJECT_ID/lighthouse eth2-pyrmont infrastructure/
```

16. Check that the deployment was successful using the
