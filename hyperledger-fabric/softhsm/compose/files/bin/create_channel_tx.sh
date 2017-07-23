
# generate channel config tx
FABRIC_CFG_PATH=/data \
 configtxgen -profile linuxctlChannel \
 -channelID testchannel \
 -outputCreateChannelTx /data/channel-artifacts/testchannel.tx \
 -inspectChannelCreateTx /data/channel-artifacts/testchannel.tx

# generate anchor peer tx
FABRIC_CFG_PATH=/data \
 configtxgen -profile linuxctlChannel \
 -channelID testchannel \
 -outputAnchorPeersUpdate /data/channel-artifacts/org1anchors.tx \
 -asOrg Org1MSP
