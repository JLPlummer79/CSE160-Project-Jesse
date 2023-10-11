#include "../../includes/packet.h"
#include "../../includes/sendInfo.h"
#include "../../includes/channels.h"

module NeighborDiscP{
    // provides shows the interface we are implementing. See lib/interface/SimpleSend.nc
    // to see what funcitons we need to implement.
   provides interface NeighborDisc;
   uses interface SimpleSend;
}

implementation{

    //have to declare variables first, not in function

    pack sendReq;
    pack sendAck;
    uint8_t* packet = "";

    uint16_t ttl = MAX_TTL;
    uint16_t ttl2 = MAX_TTL;
    uint8_t i; //used in printf in forloop
    uint16_t sequenceNum = 0;

    uint8_t NeighborList[20] = { 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255 };


    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
        Package->src = src;
        Package->dest = dest;
        Package->TTL = TTL;
        Package->seq = seq;
        Package->protocol = protocol;
        memcpy(Package->payload, &payload, length);
    }


    void PrintNeighbor(){
        //print node
        printf("Node: (%d), neighbors ", TOS_NODE_ID);

        for(i = 0; i < 20; i++){

            if(NeighborList[i] != 255 && NeighborList[i] != 0){
                printf("%d, ", i);
            }
        }
        printf("\n");
    }


   command void NeighborDisc.discNeigh(){
        if(ttl != 0){
            ttl--;
            makePack(&sendReq, TOS_NODE_ID, AM_BROADCAST_ADDR, ttl, PROTOCOL_NEIGHBOR_REQ, sequenceNum, NeighborList, packet); 
            call SimpleSend.send(sendReq, AM_BROADCAST_ADDR);
            sequenceNum++;
        }
    }

    //fucntion to send ACK
    command void NeighborDisc.sendACK(uint16_t src){
        if(ttl2 !=0){
            ttl2--;
            makePack(&sendAck, TOS_NODE_ID, src, ttl2, PROTOCOL_NEIGHBOR_ACK, TOS_NODE_ID, NeighborList, packet);
            call SimpleSend.send(sendAck, src);
        }
    }

    
    //fuction store neighborlist
    command void NeighborDisc.Store(uint16_t src){

        if(NeighborList[src] == 255){ //we havn't seen so want to update to 1
            NeighborList[src] = 1;
            PrintNeighbor();
        }
    }
}