#include "../../includes/packet.h"
#include "../../includes/sendInfo.h"
#include "../../includes/channels.h"


//implementation
generic module FloodingP(){
    // provides shows the interface we are implementing. See lib/interface/SimpleSend.nc
    // to see what funcitons we need to implement.
   provides interface NeighborDisc;
   //added
   provides interface Flooding;

   uses interface Queue<sendInfo*>;
   uses interface Pool<sendInfo>;

   uses interface Timer<TMilli> as sendTimer;

   uses interface Packet;
   uses interface AMPacket;
   uses interface AMSend;

   uses interface Random;

   pack senFld;

   /*
    command void Flooding.floodAll(){
        makePack(&sendFld, TOS_NODE_ID, AM_BROADCAST_ADDR, ttl, PROTOCOL_FLOOD, sequenceNum, NeighborList, packet)
        call SimpleSend.send(sendFld, AM_BROADCAST_ADDR);
        sequenceNum++;
    }

    command void Flooding.Store(uint16_t src) {
        //we want to store connection data associated with node
        if(not seen src){
            extract connection data associate with node
        }
    }
   */
   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
        Package->src = src;
        Package->dest = dest;
        Package->TTL = TTL;
        Package->seq = seq;
        Package->protocol = protocol;
        memcpy(Package->payload, &payload, length);
    }
}

/*
uses interface
sendTimer. startPeriodic()
call delayTimer.startOneShot(500); //500 ms

//send packet
pack beaconUp, beaconDown;
unit8_t *payload = "";
makePack(&beaconUp)

destination AM_BROADBACST_ADDR

*/