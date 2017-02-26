//
//  UDPEchoClient.h
//  UDPEcho
//
//  Created by Artem Abramov on 25/02/2017.
//  Copyright © 2017 Artem Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Completly standard and well-known approach to creating an echo client.
 
 — Create socket file descriptor (which is represented by Core Foundation's CFSocketRef and bind it to the localhost:5000
 — Since we apparently cannot run socket in `while (1)` loop (we still need main thread UI, eh?), we attach the socket to the current run loop
 — The data is sent in plain UTF-8 string with CFSocketSendData()
 — Handler block receivedMessage() is being called each time new data received in the socket.
 */

@interface UDPEchoClient : NSObject

- (void)sendString:(NSString *)string error:(NSError **)error;
- (void)setupUDPClient:(NSError **)error;
@property (nonatomic, copy) void (^receivedMessage)(NSString *message);

@end
