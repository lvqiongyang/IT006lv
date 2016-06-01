//
//  LiZiViewController.m
//  Total
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "LiZiViewController.h"

@interface LiZiViewController ()
{
    
    CAEmitterLayer *heartLayer;
    CAEmitterCell *heartCell;
    
}

@end

@implementation LiZiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
   
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self liZi];

}
- (void)liZi{

    heartLayer=[CAEmitterLayer layer];
    heartLayer.position=self.view.center;
    
    
    //粒子
    heartCell=[CAEmitterCell emitterCell];
    //出生速度
    heartCell.birthRate=10;
    //消失时间
    heartCell.lifetime=10;
    
    //从哪里出来
    //xy平面的夹角
    heartCell.emissionLongitude=0;
    //反射角度范围
    heartCell.emissionRange=M_PI *2;
    
    //速度
    heartCell.velocity=100; //方向
    heartCell.velocityRange=50;//范围
    //加速
    heartCell.yAcceleration=10;//旋转方向
    heartCell.spinRange=M_PI *2;//旋转角度
    
    //图片
    heartCell.contents=(__bridge id _Nullable)([UIImage imageNamed:@"DazHeart"].CGImage);
    //颜色
    heartCell.color= [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
    heartCell.redRange = 1;
    heartCell.blueRange = 1;
    heartCell.greenRange = 1;
    heartCell.alphaSpeed=-1/heartCell.lifetime;
    
    
    //粒子的初始大小
    heartCell.scale=0.1;
    //粒子大小的变化速度
    heartCell.scaleSpeed=0.3;
    
    
    //粒子发射时候的大小
    heartLayer.emitterSize=CGSizeMake(100, 100);
    
    //粒子发射模式
    heartLayer.emitterMode=kCAEmitterLayerPoints;
    
    //粒子发射形状
    heartLayer.emitterShape=kCAEmitterLayerCircle;
    
    //粒子混合效果
    heartLayer.renderMode=kCAEmitterLayerOldestLast;
    
    heartLayer.emitterCells=@[heartCell];
    [self.view.layer addSublayer:heartLayer];
    
    // [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTimer) userInfo:nil repeats:YES];

}
- (void)changeTimer{
    
    heartLayer.position=CGPointMake(arc4random()%314, arc4random()%636);
    
}
- (IBAction)backBtn:(UIButton *)sender {
    
    CATransition *animation=[CATransition animation];
    animation.duration=2;
    animation.type=@"pageUnCurl";
    animation.subtype=kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];

    
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
