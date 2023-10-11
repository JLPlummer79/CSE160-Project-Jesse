/*
 * ANDES Lab - University of California, Merced
 * This class provides the basic functions of a network node.
 *
 * @author UCM ANDES Lab
 * @date   2013/09/03
 *
 */
#include <Timer.h>
#include "includes/command.h"
#include "includes/packet.h"
#include "includes/CommandMsg.h"
#include "includes/sendInfo.h"
#include "includes/channels.h"

module Node{
   uses interface Boot;

   uses interface SplitControl as AMControl;
   uses interface Receive;

   uses interface SimpleSend as Sender;

   uses interface CommandHandler;
   //what I have added
   uses interface NeighborDisc;
//   uses interface Flooding;

   uses interface Timer<TMilli> as NeighborT;
   //uses interface Timer<TMilli> as FloodT;
}

implementation{
   pack sendPackage;
   bool done = FALSE;
   // Prototypes                nodeid          nodeid       number of hops                                        packet ID
   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);

//boot each node
   event void Boot.booted(){
      call AMControl.start();

      dbg(GENERAL_CHANNEL, "Booted\n");
   }
//node has been booted
   event void AMControl.startDone(error_t err){
      if(err == SUCCESS){
         dbg(GENERAL_CHANNEL, "Radio On\n");
         call NeighborT.startPeriodic(50000);
         //call FloodT.startOneShot(500); 
      }else{
         //Retry until successful
         call AMControl.start();
      }
   }

   event void AMControl.stopDone(error_t err){}

//What to do when recieve a packet
   event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
      //dbg(GENERAL_CHANNEL, "Packet Received\n");
      if(len==sizeof(pack)){
         pack* myMsg=(pack*) payload;

         //dbg(GENERAL_CHANNEL, "Packet Received %d\n", myMsg->protocol);
         //if recieve request send ACK
         if(myMsg->protocol == PROTOCOL_NEIGHBOR_REQ){
            //send ACK to src node
            call NeighborDisc.sendACK(myMsg->src); 
         }
         //store addres when protocol ACK
         if(myMsg->protocol == PROTOCOL_NEIGHBOR_ACK){
            call NeighborDisc.Store(myMsg->src);
         }

         //dbg is DEBUG message
         //dbg(GENERAL_CHANNEL, "Package Payload: %s\n", myMsg->payload);
         //output seq and TTL
         //dbg(GENERAL_CHANNEL, "Received Payload From: %d %d", myMsg->seq, myMsg->TTL);
         return msg;
      }
      dbg(GENERAL_CHANNEL, "Unknown Packet Type %d\n", len);
      return msg;
   }

//ping event
   event void CommandHandler.ping(uint16_t destination, uint8_t *payload){
      dbg(GENERAL_CHANNEL, "PING EVENT \n");
      makePack(&sendPackage, TOS_NODE_ID, destination, 0, 0, 0, payload, PACKET_MAX_PAYLOAD_SIZE);
      call Sender.send(sendPackage, destination);
   }

   //calls NeighborDisc
   event void NeighborT.fired(){
      if(!done)
         call NeighborDisc.discNeigh();
      done = TRUE;
   }

   /*
      event void FloodT.fired() {
         call Flooding.floodAll();
         rock 
      }
   */

   event void CommandHandler.printNeighbors(){}

   event void CommandHandler.printRouteTable(){}

   event void CommandHandler.printLinkState(){}

   event void CommandHandler.printDistanceVector(){}

   event void CommandHandler.setTestServer(){}

   event void CommandHandler.setTestClient(){}

   event void CommandHandler.setAppServer(){}

   event void CommandHandler.setAppClient(){}

   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
      Package->src = src;
      Package->dest = dest;
      Package->TTL = TTL;
      Package->seq = seq;
      Package->protocol = protocol;
      memcpy(Package->payload, payload, length);
   }
}
