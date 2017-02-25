//
//  UDPEchoClient.m
//  UDPEcho
//
//  Created by Artem Abramov on 25/02/2017.
//  Copyright © 2017 Artem Abramov. All rights reserved.
//

#import "UDPEchoClient.h"

#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define IP      "127.0.0.1"
#define PORT    50000

NSString * const UDPEchoClientErrorDomain = @"UDPEchoClientErrorDomain";

@interface UDPEchoClient ()

@property (nonatomic, assign) CFSocketRef socket;
@property (nonatomic, assign) struct sockaddr_in addr;

@end


@implementation UDPEchoClient
{
    CFSocketRef socket;

    struct sockaddr_in  addr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)sendString:(NSString *)string error:(NSError **)error {
    if (socket)
    {
        //
        //  making the data from the address
        //
        CFDataRef addr_data = CFDataCreate(NULL, (const UInt8*)&addr, sizeof(addr));
        
        //
        //  making the data from the message
        //
        CFDataRef msg_data  = CFDataCreate(NULL, (const UInt8*)string.UTF8String, strlen(string.UTF8String));
        
        CFSocketError socketErr = CFSocketSendData(socket, addr_data, msg_data, 0);
        if (socketErr == kCFSocketSuccess) {
            *error = [NSError errorWithDomain:UDPEchoClientErrorDomain code:0 userInfo:nil];
        }
        return;
    }
    else {
        NSLog(@"socket reference is null");
        *error = [NSError errorWithDomain:UDPEchoClientErrorDomain code:0 userInfo:nil];
        return;
    }
}

- (void)setupUDPClient:(NSError **)error {
    
    CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketDataCallBack, &DataCallBack, &socketCtxt);
    
    if (NULL == socket) {
        if (error) {
            *error = [NSError errorWithDomain:UDPEchoClientErrorDomain code:0 userInfo:nil];
        }
        return;
    }
    
    memset(&addr, 0, sizeof(addr));
    
    addr.sin_len            = sizeof(addr);
    addr.sin_family         = AF_INET;
    addr.sin_port           = htons(PORT);
    addr.sin_addr.s_addr    = inet_addr(IP);
    
    //
    // set runloop for data reciever
    //
    CFRunLoopSourceRef rls = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopCommonModes);
    CFRelease(rls);
}

static void DataCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    UDPEchoClient *client = (__bridge UDPEchoClient *)info;
    CFDataRef dataRef = (CFDataRef)data;
    NSLog(@"data recieved (%s) ", CFDataGetBytePtr(dataRef));
    NSString *string = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataRef) encoding:NSASCIIStringEncoding];
    client.receivedMessage(string);
}

@end
