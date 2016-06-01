//
//  ToolInternet.m
//  Total
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "ToolInternet.h"
#import "Reachability.h"

@implementation ToolInternet
+ (BOOL)haveWifi{
    Reachability *rech=[Reachability reachabilityWithHostName:@"https:www.apple.com"];
    if (rech.currentReachabilityStatus==NotReachable) {
        return NO;
    }
    return YES;
}
+ (BOOL)haveGPRS{
    Reachability *rech=[Reachability reachabilityWithHostName:@"https:www.apple.com"];
    if (rech.currentReachabilityStatus==NotReachable) {
        return NO;
    }
    
    
    return YES;
}
+ (NSString *)getPath{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Microsoft-iOS.ImageCache/fsCachedData/"];
    
}

@end
