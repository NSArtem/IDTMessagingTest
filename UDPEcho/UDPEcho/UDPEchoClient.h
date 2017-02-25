//
//  UDPEchoClient.h
//  UDPEcho
//
//  Created by Artem Abramov on 25/02/2017.
//  Copyright © 2017 Artem Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDPEchoClient : NSObject

- (void)sendString:(NSString *)string error:(NSError **)error;
- (void)setupUDPClient:(NSError **)error;
@property (nonatomic, copy) void (^receivedMessage)(NSString *message);

@end
