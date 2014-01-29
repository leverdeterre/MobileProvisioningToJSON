//
//  main.m
//  mb2json
//
//  Created by Jerome Morissard on 1/29/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDictionary+iAppInfos.h"
#import "JMOMobileProvisionning.h"
#import "JMOMobileProvisionning+mb2json.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        if(argc < 2)
        {
            fprintf(stderr, "Usage: ./mb2json [mobile provisioning path]\n");
            exit(-1);
        }
        
        
        // convert path to NSString
        NSString *path = [NSString stringWithUTF8String:argv[1]];
        NSString *result = nil;
        
        // Check provisioning profile existence
        if (path)
        {
            // Get hex representation
            NSData *profileData = [NSData dataWithContentsOfFile:path];
            NSString *profileString = [NSString stringWithFormat:@"%@", profileData];
            
            // Remove brackets at beginning and end
            profileString = [profileString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            profileString = [profileString stringByReplacingCharactersInRange:NSMakeRange(profileString.length - 1, 1) withString:@""];
            
            // Remove spaces
            profileString = [profileString stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            // Convert hex values to readable characters
            NSMutableString *profileText = [NSMutableString new];
            for (int i = 0; i < profileString.length; i += 2)
            {
                NSString *hexChar = [profileString substringWithRange:NSMakeRange(i, 2)];
                int value = 0;
                sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
                [profileText appendFormat:@"%c", (char)value];
            }
            
            NSRange range1 = [profileText rangeOfString:@"<?xml"];
            if ( range1.location != NSNotFound ) {
                NSRange range2 = [profileText rangeOfString:@"</plist>"];
                if ( range2.location != NSNotFound ) {
                    NSRange range = NSMakeRange(range1.location, range2.location + range2.length - range1.location);
                    result = [profileText substringWithRange:range];
                    
                    NSDictionary *dict = [NSDictionary jmo_dictionaryWithMobileProvisioningString:result];
                    JMOMobileProvisionning *provisionningObj = [[JMOMobileProvisionning alloc] initWithDictionary:dict];
                    NSLog(@"%@",[provisionningObj jsonStringWithPrettyPrint:YES]);
                }
            }
        }
        
    }
    return 0;
}

