#include "../../includes/am_types.h"
//active messaging

generic configuration SimpleSendC(int channel){
   provides interface SimpleSend;
}

//implementation details simplesend
implementation{
   //create instance simplesendP
   components new SimpleSendP();
   SimpleSend = SimpleSendP.SimpleSend;

   components new TimerMilliC() as sendTimer;
   //possible for random values
   components RandomC as Random;
   //specified channel
   components new AMSenderC(channel);

   //Timers
   SimpleSendP.sendTimer -> sendTimer;
   SimpleSendP.Random -> Random;

   SimpleSendP.Packet -> AMSenderC;
   SimpleSendP.AMPacket -> AMSenderC;
   SimpleSendP.AMSend -> AMSenderC;

   //Lists, message handling
   components new PoolC(sendInfo, 20);
   components new QueueC(sendInfo*, 20);

   SimpleSendP.Pool -> PoolC;
   SimpleSendP.Queue -> QueueC;
}
