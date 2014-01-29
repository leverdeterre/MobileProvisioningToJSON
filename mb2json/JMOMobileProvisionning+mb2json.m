//
//  JMOMobileProvisionning+mb2json.m
//  mb2json
//
//  Created by Jerome Morissard on 1/29/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "JMOMobileProvisionning+mb2json.h"

@implementation JMOMobileProvisionning (mb2json)

- (NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.summary
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
