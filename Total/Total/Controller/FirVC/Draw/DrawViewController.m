//
//  DrawViewController.m
//  Total
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 Lnote. All rights reserved.
//
#define HIGHT self.view.frame.size.height
#import "DrawViewController.h"
#import "DrawView.h"

@interface DrawViewController (){

    DrawView *_draw;
    UIView *myView;
    NSInteger widthNum;
 
}
@property (nonatomic,retain) NSArray *arrWord;
@property (nonatomic,retain) NSArray *arrColor;
@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [UIApplication sharedApplication].statusBarHidden=YES;
    self.view.frame=[UIScreen mainScreen].bounds;
    self.view.backgroundColor=[UIColor magentaColor];
    DrawView *draw=[[DrawView alloc]init];
    draw.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    draw.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:draw];
    _draw=draw;
    
    
    widthNum=5;
    
    [draw release];
    
    [self buttons];
    
    
    [self initMyView];
    
}
- (void)initMyView{
    
    myView=[UIView new];
    myView.frame=CGRectMake(0, 0, 40, self.view.frame.size.height-50);
    myView.backgroundColor=[UIColor magentaColor];
    myView.hidden=YES;
    [self.view addSubview:myView];
    [self buttonsTool];


}

- (void)buttonsTool{
    
   
    self.arrColor=@[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor blackColor],[UIColor lightGrayColor],[UIColor grayColor]];
    self.arrWord=@[@"红\n色",@"黄\n色",@"蓝\n色",@"绿\n色",@"橘\n黄",@"紫\n色",@"黑\n色",@"加\n粗",@"变\n细"];
    
    
    for (int i = 0; i<9; i++) {
         UIButton *btnTool=[UIButton buttonWithType:UIButtonTypeSystem];
        btnTool.frame=CGRectMake(0+(40+0)*(i%1), 0+(myView.frame.size.height/9+0)*(i/1), 40, myView.frame.size.height/9);
        btnTool.tag=100+i;
        btnTool.titleLabel.numberOfLines=0;
        btnTool.backgroundColor=_arrColor[i];
        [btnTool.layer setBorderColor:[UIColor brownColor].CGColor];
        [btnTool.layer setBorderWidth:5];
        [btnTool setTitle:_arrWord[i] forState:UIControlStateNormal];
        btnTool.titleLabel.textAlignment=NSTextAlignmentCenter;
       // btnTool.titleLabel.font=[UIFont systemFontOfSize:25 weight:25];
        [btnTool setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnTool.layer.cornerRadius=5;
        btnTool.clipsToBounds=YES;
        [myView addSubview:btnTool];
        [btnTool addTarget:self action:@selector(colorChangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
   
    


}
- (void)buttons{
    UIButton *left=[UIButton buttonWithType:UIButtonTypeCustom];
    left.frame=CGRectMake(self.view.frame.size.width/9, self.view.frame.size.height-50, 50, 50);
    [left setBackgroundImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    [left setTitle:@"保存" forState:UIControlStateNormal];
    left.clipsToBounds=YES;
    left.layer.cornerRadius=15;
    [left setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:left];
    [left addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *left1=[UIButton buttonWithType:UIButtonTypeCustom];
    left1.frame=CGRectMake(self.view.frame.size.width*3/9, self.view.frame.size.height-50, 50, 50);
    [left1 setBackgroundImage:[UIImage imageNamed:@"0.jpg"] forState:UIControlStateNormal];
    [left1 setTitle:@"撤销" forState:UIControlStateNormal];
    left1.clipsToBounds=YES;
    left1.layer.cornerRadius=15;
    [left1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:left1];
    [left1 addTarget:self action:@selector(leftBtn1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    right.frame=CGRectMake(self.view.frame.size.width*5/9, self.view.frame.size.height-50, 50, 50);
    [right setBackgroundImage:[UIImage imageNamed:@"4.jpg"] forState:UIControlStateNormal];
    [right setTitle:@"放弃" forState:UIControlStateNormal];
    right.clipsToBounds=YES;
    right.layer.cornerRadius=15;
    [right setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:right];
    [right addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *right1=[UIButton buttonWithType:UIButtonTypeCustom];
    right1.frame=CGRectMake(self.view.frame.size.width*7/9, self.view.frame.size.height-50, 50, 50);
    [right1 setBackgroundImage:[UIImage imageNamed:@"3.jpeg"] forState:UIControlStateNormal];
    [right1 setTitle:@"退出" forState:UIControlStateNormal];
    right1.clipsToBounds=YES;
    right1.layer.cornerRadius=15;
    [right1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:right1];
    [right1 addTarget:self action:@selector(rightBtn1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *show=[UIButton buttonWithType:UIButtonTypeSystem];
    show.frame=CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width*0.5/9, 50);
    show.titleLabel.numberOfLines=0;
    show.titleLabel.adjustsFontSizeToFitWidth=YES;
   // [show setBackgroundColor:[UIColor redColor]];
    [show setTitle:@"显示" forState:UIControlStateNormal];
    [show setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:show];
    [show addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *unshow=[UIButton buttonWithType:UIButtonTypeSystem];
    unshow.frame=CGRectMake(self.view.frame.size.width*8.5/9, self.view.frame.size.height-50, self.view.frame.size.width*0.5/9, 50);
    unshow.titleLabel.numberOfLines=0;
    unshow.titleLabel.adjustsFontSizeToFitWidth=YES;
   // [unshow setBackgroundColor:[UIColor redColor]];
    [unshow setTitle:@"隐藏" forState:UIControlStateNormal];
    [unshow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:unshow];
    [unshow addTarget:self action:@selector(unshowBtn:) forControlEvents:UIControlEventTouchUpInside];
    

}
- (void)leftBtn:(UIButton *)sender{
   
    [_draw saveImage];
    
    
}
- (void)leftBtn1:(UIButton *)sender{
    
    
    [_draw dropDrawLast];
    
}
- (void)rightBtn:(UIButton *)sender{
   
    [_draw dropDraw];
  
}
- (void)rightBtn1:(UIButton *)sender{
    
    CATransition *animation=[CATransition animation];
    animation.duration=1;
    animation.type=kCATransitionPush;
    animation.subtype=kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)showBtn:(UIButton *)sender{
   
    if (myView.hidden==YES) {
        CATransition *animation=[CATransition animation];
        animation.duration=1;
        animation.type=kCATransitionPush;
        animation.subtype=kCATransitionFromLeft;
        [myView.layer addAnimation:animation forKey:nil];
        
        _draw.frame=CGRectMake(40, 0, self.view.frame.size.width-40, self.view.frame.size.height-50);
        myView.hidden=NO;
        NSLog(@"------显示调色板");
        
    }
    
  

}
- (void)unshowBtn:(UIButton *)sender{
    
    if (myView.hidden ==NO) {
        
        CATransition *animation=[CATransition animation];
        animation.duration=1;
        animation.type=kCATransitionPush;
        animation.subtype=kCATransitionFromRight;
        [myView.layer addAnimation:animation forKey:nil];
       
        
        _draw.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
        myView.hidden=YES;
        NSLog(@"++++隐藏调色板");
        

        
    }
    
}
- (void)colorChangeBtnClick:(UIButton *)sender{

    NSLog(@"当前点击的是%@",_arrWord[sender.tag-100]);
    NSInteger ss=sender.tag-100;
    NSLog(@"%ld",ss);
    if (sender.tag-100<7) {
         [_draw passColoNumber:ss];
    }else{
    
        if (sender.tag-100==7) {
            widthNum=widthNum+1;
           
            
        }else if (sender.tag-100==8){
            widthNum=widthNum-1;
            
        }
 NSLog(@"---%ld",widthNum);
        [_draw passColowidth:widthNum];
    
    }
    
   
    
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
