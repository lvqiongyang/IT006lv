//
//  DrawView.h
//  Total
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
- (void)saveImage;
- (void)dropDraw;
- (void)dropDrawLast;
-(NSInteger )passColoNumber:(NSInteger )sp;
-(NSInteger )passColowidth:(NSInteger )width;

@end
