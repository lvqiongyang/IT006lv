//
//  HandViewController.m
//  Total
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "HandViewController.h"

@interface HandViewController ()

@end

@implementation HandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self handEvent];
    
}
- (IBAction)backBtn:(UIButton *)sender {
    
    
    CATransition *animation =[CATransition animation];
    animation.duration=1;
    animation.type=@"cameraIrisHollowClose";
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handEvent{
    UIPanGestureRecognizer *pan=[UIPanGestureRecognizer new];
    pan.cancelsTouchesInView=YES;
    pan.delaysTouchesBegan=YES;
    pan.delaysTouchesEnded=NO;
    [pan addTarget:self action:@selector(panEvent:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
    
    UIPinchGestureRecognizer *pinch=[UIPinchGestureRecognizer new];
    [pinch addTarget:self action:@selector(pinchEvent:)];
    [self.view addGestureRecognizer:pinch];
    [pinch release];
    
    
    UISwipeGestureRecognizer *swipe=[UISwipeGestureRecognizer new];
    [swipe addTarget:self action:@selector(swipeEvent:)];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    [swipe release];
    
    
    
    UILongPressGestureRecognizer *longP=[UILongPressGestureRecognizer new];
    [longP addTarget: self action:@selector(longPEvent:)];
    [self.view addGestureRecognizer:longP];
    [longP release];
    
    UIRotationGestureRecognizer *rotation=[UIRotationGestureRecognizer new];
    [rotation addTarget:self action:@selector(rotationEvent:)];
    [self.view addGestureRecognizer:rotation];
    [rotation release];



}
- (void)panEvent:(id)sender{

    NSLog(@"拖拽");
    self.view.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    

}
- (void)pinchEvent:(id)sender{
    
     NSLog(@"捏合");
    
}
- (void)swipeEvent:(id)sender{
     NSLog(@"轻滑");
    
    
}
- (void)longPEvent:(id)sender{
    
     NSLog(@"长按");
    
}
- (void)rotationEvent:(id)sender{

 NSLog(@"旋转");


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
