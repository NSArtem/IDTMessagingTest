//
//  main.m
//  ReverseString
//
//  Created by Artem Abramov on 25/02/2017.
//  Copyright © 2017 Artem Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 If we will use the regular approach with cycle reversing of the string byte by byte, the string will get mutilated as the emojis are essentially multi-UTF characters. In order to avoid that we go by so-called "Composed Character Sequences", that correctly detects this group of UTF characters.
 */

NSString * reverseString(NSString *string) {
    if (string.length <= 0) {
        return nil;
    }
    
    NSMutableString *reversedString = [NSMutableString new];
    NSUInteger position = string.length;
    
    while (position > 0) {
        NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:position - 1];
        NSString *substring = [string substringWithRange:range];
        [reversedString appendString:substring];
        position = range.location;
    }
    
    return reversedString.copy;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Reversing simple string: \n%@\n", reverseString(@"The quick brown fox jumps over the lazy dog"));
        NSLog(@"Reversing string with UTF characters: \n%@\n", reverseString(@"🇫🇮 On sangen hauskaa, että polkupyörä on maanteiden jokapäiväinen ilmiö. 😜"));
        NSLog(@"Reversing string with UTF characters: \n%@\n", reverseString(@"🇷🇺 Съешь же ещё этих мягких французских булок да выпей чаю. 😀"));
    }
    return 0;
}
