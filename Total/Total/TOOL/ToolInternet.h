//
//  ToolInternet.h
//  Total
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolInternet : NSObject

+ (BOOL)haveWifi;
+ (BOOL)haveGPRS;
+ (NSString *)getPath;
@end
