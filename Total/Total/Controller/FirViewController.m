//
//  FirViewController.m
//  Total
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "FirViewController.h"
#import "LiZiViewController.h"
#import "DrawViewController.h"
#import "SDViewController.h"
#import "HandViewController.h"
#import "HeXinViewController.h"
#import "AplleVC.h"

@interface FirViewController ()

@end

@implementation FirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor magentaColor];
}
- (IBAction)goLiZi:(UIButton *)sender {
    
    LiZiViewController *lVC=[[LiZiViewController new]autorelease];
    
    CATransition *animation=[CATransition animation];
    animation.duration=2;
    animation.type=@"pageCurl";
    animation.subtype=kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    [self presentViewController:lVC animated:YES completion:nil];
    
    
    
    
}

- (IBAction)goDrawBtn:(UIButton *)sender {
    
    DrawViewController *dVC=[[DrawViewController new]autorelease];
    
    CATransition *animation=[CATransition animation];
    animation.duration=1;
    animation.type=kCATransitionPush;
    animation.subtype=kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:dVC animated:YES];
    
    
    
}

- (IBAction)animationBtn:(UIButton *)sender {
    HeXinViewController *hVC=[[HeXinViewController new]autorelease];
    
    
    
    
    [self.navigationController pushViewController:hVC animated:YES];
    
    
    
}

- (IBAction)lockBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goSDImage:(UIButton *)sender {
    
    SDViewController *sVC=[[SDViewController new]autorelease];
    
    CATransition *animation=[CATransition animation];
    animation.duration=1.5;
    animation.type=@"rippleEffect";
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self.navigationController pushViewController:sVC animated:YES];
    
}

- (IBAction)goHandBtn:(UIButton *)sender {
    HandViewController *hVC=[[HandViewController new]autorelease];
    CATransition *animation =[CATransition animation];
    animation.duration=1;
    animation.type=@"cameraIrisHollowOpen";
   
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    
    [self.navigationController pushViewController:hVC animated:YES];
    
    
}

- (IBAction)goGameBtn:(UIButton *)sender {
    AplleVC *aVC=[[AplleVC new]autorelease];
    
    CATransition *animation=[CATransition animation];
    animation.duration=1.5;
    animation.type=kCATransitionMoveIn;
    animation.subtype=kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    [self.navigationController pushViewController:aVC animated:YES];
    
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

- (void)dealloc {
    [_liZiBtn release];
    [super dealloc];
}
@end
