//
//  ADYServerSynchronization.h
//  AdyenPOSLib
//
//  Created by Jeroen Koops on 6/10/13.
//
//

#ifndef AdyenPOSLib_ADYServerSynchronization_h
#define AdyenPOSLib_ADYServerSynchronization_h

typedef NS_ENUM(NSUInteger, ADYServerSynchronizerState) {
    ADYServerSynchronizerStateWaitingForNetwork = 0,
    ADYServerSynchronizerStateSynchronizing = 1,
    ADYServerSynchronizerStateIdle = 2,
} ;

#endif
