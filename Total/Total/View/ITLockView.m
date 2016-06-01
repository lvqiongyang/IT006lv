//
//  ITLockView.m
//  IT006LockDemo
//
//  Created by lwx on 16/5/10.
//  Copyright © 2016年 lwx. All rights reserved.
//

#import "ITLockView.h"

@interface ITLockView ()

@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, retain) NSMutableArray *buttons;

@end

@implementation ITLockView


- (NSMutableArray *)buttons {
    if (!_buttons) {
        self.buttons = [NSMutableArray array];
    
    }
    return _buttons;
}

#pragma mark - 用代码写的时候调用
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createButtons];
    }
    return self;
}

#pragma mark - 用XIB拖得时候回调用
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%s",__FUNCTION__);
        [self createButtons];
    }
    return self;
}

//tableViewCell的init方法
//initwithstyle ... id...


- (void)createButtons {
    
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40 + i % 3  * (80 + 40) , 40 + i / 3 * 120, 80, 80);
        button.tag=100+i;
        [button setBackgroundImage:[UIImage imageNamed:@"n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"s"] forState:UIControlStateSelected];
        
        button.userInteractionEnabled = NO;
        
        [self addSubview:button];
        
        
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //获取当前touch的点
    CGPoint point = [touches.anyObject locationInView:self];
    //遍历所有按钮
    for (UIButton *btn in self.subviews) {
        
        //如果当前点的坐标在某个按钮范围内
        if (CGRectContainsPoint(btn.frame, point)) {
            //改变按钮的selected属性
            btn.selected = YES;
            //按钮加入到数组中
            [self.buttons addObject:btn];
        }
    }
    //重绘
    [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [touches.anyObject locationInView:self];
    
    //记录当前点
    self.currentPoint = point;
    
    for (UIButton *btn in self.subviews) {
        //遍历按钮的同时，不遍历已经被选择的按钮
        if (CGRectContainsPoint(btn.frame, point) && !btn.selected) {
            btn.selected = YES;
            [self.buttons addObject:btn];
        }
    }
    //需要重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //1.清空数据
    [self.buttons removeAllObjects];
    //2.重绘视图
    [self setNeedsDisplay];
    //3.遍历按钮，改变selected属性
    for (UIButton *btn in self.subviews) {
        btn.selected = NO;
    }
   
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"jieshu",@"key", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jiesuo" object:nil userInfo:dic];
    
    
}


- (void)drawRect:(CGRect)rect {
    
    if (self.buttons.count == 0) {
        return;
    }
    
    //1.获得context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, 5);
    //2.获得第一个按钮
    UIButton *btn = self.buttons[0];
    //3.移动到第一个按钮中心开始画线
    CGContextMoveToPoint(context, btn.center.x, btn.center.y);
    
    //4.addline
    for (NSInteger i = 1; i < self.buttons.count; i++) {
        UIButton *endBtn = self.buttons[i];
        
        CGContextAddLineToPoint(context, endBtn.center.x, endBtn.center.y);
        
    }
    
    CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
    
    //5.描边
    CGContextStrokePath(context);
    NSMutableString *passWord=[NSMutableString string];
    for (UIButton *btn in self.buttons) {
        NSString *str=[NSString stringWithFormat:@"%ld",btn.tag-100];
        [passWord appendString:str];
        
    }
    
    
    NSLog(@"当前密码是:%@",passWord);
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:passWord,@"key", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mima" object:nil userInfo:dic];
    
    
}
- (void)dealloc{

    [_buttons release];
    [super dealloc];
}

@end
