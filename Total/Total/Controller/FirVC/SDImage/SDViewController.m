//
//  SDViewController.m
//  Total
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "SDViewController.h"
#import "UIImageView+WebCache.h"
#import "ToolInternet.h"


@interface SDViewController ()

@end

@implementation SDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.labelInternet.layer.cornerRadius=5;
    self.labelInternet.clipsToBounds=YES;
    self.labelInternet.text=@"请按网络测试按钮测试网路....";
    NSLog(@"%@",NSHomeDirectory());
    
    
}
- (IBAction)goStratBtn:(UIButton *)sender {
   
    UIImage *placeholder=[UIImage imageNamed:@"0.jpg"];

    if ([ToolInternet haveWifi]) {
        
        
       NSLog(@"wif下载");
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic41.nipic.com/20140501/2531170_162158900000_2.jpg"]placeholderImage:placeholder];
        
    }else if ([ToolInternet haveGPRS]){
        NSLog(@"数据下载假");
    
    
    }
    
    
    
    
    
    
    
    
}
- (IBAction)goBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)testBtn:(UIButton *)sender {
    if ([ToolInternet haveWifi]) {
        
        self.labelInternet.text=@"WIFI在线,可以为所欲为的下载了";
    }else if ([ToolInternet haveGPRS]) {
      
        
        self.labelInternet.text=@"数据流量在线,为了您的钱袋子请谨慎下载";
     
    
    }else{
    
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"哎呀我去，信号太差，手也酸了，换个位置，换个姿势，再试一次吧" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    
    
    }
    
    
    
    
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
    [_myImageView release];
    [_labelInternet release];
    [super dealloc];
}
@end
