//
//  main.m
//  DoubleAutorelease
//
//  Created by Artem Abramov on 25/02/2017.
//  Copyright © 2017 Artem Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 What does `autorelease` do?
 Essentially it adds the object to some storage (most probably that is a simple array), and once the pool is drained to all the objects in this array are sent `release` messages.
 
    If the object is just allocated and inited, its retain count is 1, thus if the `autorelease` is called twise, to this object `release` call will be sent twice, resulting in overrelease and crash.
 
    Apparently if the retain count is actually incremented, it should be balanced with a `release` call, consequently making a second `autorelease` call a necessity in some cases.
 
    Two examples beneath illustrate balancing release/retain calls with one autoreleasepool and nested autoreleasepools.
 */

int main(int argc, const char * argv[]) {
    
    //example 1
    NSAutoreleasePool *secondPool = [[NSAutoreleasePool alloc] init];
    NSObject *secondObject = [[[NSObject alloc] init] autorelease];
    [[secondObject retain] autorelease];
    NSLog(@"%p", secondObject);
    [secondPool drain];
 
    //example 2
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSObject *object = [[[NSObject alloc] init] autorelease];
    NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
    [[object retain] autorelease];
    NSLog(@"%p", object);
    [innerPool drain];
    [pool drain];

    return 0;
}
