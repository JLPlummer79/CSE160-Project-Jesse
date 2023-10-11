#include "../../includes/am_types.h"

//not a function no input
configuration NeighborDiscC{
   provides interface NeighborDisc;
}

implementation{

   components NeighborDiscP;
   NeighborDisc = NeighborDiscP;
   components new SimpleSendC(AM_PACK);
   //components new HashmapC(uint32_t, 20) as NeighMap;

   NeighborDiscP.SimpleSend -> SimpleSendC;

}