#include "../../includes/am_types.h"

//configuration
generic configuration FloodingC(int channel){
   provides interface Flooding;
}

implementation{
   components FloodingP;
   Flooding = FloodingP;
   components new SimpleSendC(AM_BROADCAST_ADDR);
   //components new HashmapC(uint32_t, 20) as FloodMap;

   FloodingP.SimpleSend -> SimpleSendC;
}

