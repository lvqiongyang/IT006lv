//
//  DrawView.m
//  Total
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()

@property (nonatomic,retain)NSMutableArray *lineArr;
@property (nonatomic,retain)NSMutableArray *lineArrColor;
@property (nonatomic,retain) NSMutableArray *arrAnyColor;
@property (nonatomic,assign) NSInteger sp;
@property (nonatomic,assign) NSInteger spWith;


@end

@implementation DrawView
- (NSMutableArray *)lineArr{
    if (_lineArr==nil) {
        self.lineArr=[NSMutableArray array];
    }
    return _lineArr;

}
- (NSMutableArray *)lineArrColor{
    if (_lineArrColor==nil) {
        self.lineArrColor=[NSMutableArray array];
    }
    return _lineArrColor;

}
- (NSMutableArray *)arrAnyColor{
    if (_arrAnyColor==nil) {
        self.arrAnyColor=[NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor blackColor], nil];
    }

    return _arrAnyColor;

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     //UITouch 触摸事件类
    UITouch *touch=[touches anyObject];
    //从touch对象中获得point
    CGPoint point=[touch locationInView:self];
    NSMutableArray *pointArr=@[].mutableCopy;
    [pointArr addObject:[NSValue valueWithCGPoint:point]];
    [self.lineArr addObject:pointArr];
   
    
 
    
    
    NSLog(@"1111++++");

}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point=[touches.anyObject locationInView:self];
      NSMutableArray *pointArr=[self.lineArr lastObject];
    [pointArr addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
    NSLog(@"2222++++");
}
- (NSInteger )passColoNumber:(NSInteger)sp{
    _sp=sp;
    
    
    return _sp;


}
-(NSInteger )passColowidth:(NSInteger )width{
    _spWith=width;
    
    NSLog(@"++++%ld",_spWith);
    
    return _spWith;


}

- (void)drawRect:(CGRect)rect{

    NSLog(@"3333++++");
    CGContextRef content=UIGraphicsGetCurrentContext();

    if (_sp<7) {
        [self.arrAnyColor[_sp] setStroke];
        
    }
    
    if (_spWith>0) {
         CGContextSetLineWidth(content, _spWith);
        
    }else{
        CGContextSetLineWidth(content, 5);
    }
    
    
    
      
    for (NSMutableArray *pointArr in self.lineArr) {
        CGPoint beginPoint=[pointArr[0] CGPointValue];
        CGContextMoveToPoint(content, beginPoint.x, beginPoint.y);
    
        for (NSInteger i = 1; i<pointArr.count; i++) {
            CGPoint endPoint=[pointArr[i] CGPointValue];
            CGContextAddLineToPoint(content, endPoint.x, endPoint.y);
        }
        
      
        
        
    }
    
      CGContextStrokePath(content);

}
- (void)saveImage{
    
    if (self.lineArr.count>0) {
        // 准备 image 的上下文 用来画图
        UIGraphicsBeginImageContext(self.bounds.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        //接收图片
        UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
        //关闭 imageContext
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError: contextInfo:), nil);
    }else{
    
        NSLog(@"请先画图,然后再保存");
    
    }
    
  
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *str;
    
    if (!error) {
        NSLog(@"成功");
        str=@"保存成功";
    
    }else{
        
        NSLog(@"失败");
        str=@"保存失败";
    }
    
    
    
    
//    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
//    
//   
//    
//    if (!error) {
//        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:sure];
//    }else{
//        UIAlertAction *canncel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:canncel];
//    }
//    
//    [alert presentViewController:alert animated:YES completion:nil];
    
}

- (void)dropDraw{
    if (self.lineArr.count>0) {
        
        [self.lineArr removeAllObjects];
        
        //需要显示视图上画的内容是就要调用
        [self setNeedsDisplay];
        
    }


}
- (void)dropDrawLast{

    if (self.lineArr.count>0) {
        
        [self.lineArr removeLastObject];
        
        //需要显示视图上画的内容是就要调用
        [self setNeedsDisplay];
        
    }



}

@end
