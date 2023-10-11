#include "../../includes/packet.h"


//functionality of components
interface Flooding{
   command error_t send(pack msg, uint16_t dest );

}

// //implement the interface
// implementation{
   

//     // Implement the commands and events defined in the interface
//     command error_t Flooding.send(pack msg, uint16_t dest) {
//         // Your implementation here
//         // You can use the makePack function if needed
//         // ...
//         return SUCCESS; // Return an appropriate error code
//     }


//    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
//       Package->src = src;
//       Package->dest = dest;
//       Package->TTL = TTL;
//       Package->seq = seq;
//       Package->protocol = protocol;
//       memcpy(Package->payload, payload, length);
//    }
// }

