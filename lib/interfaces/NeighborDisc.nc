#include "../../includes/packet.h"

//similar to .h file which provides list of functions
interface NeighborDisc{

   //need to specify functions
   command void discNeigh();
   //function ACK
   command void sendACK(uint16_t src);
   //fuction store Neighborlist
   command void Store(uint16_t src);


   //command error_t send(pack msg, uint16_t dest );
}
