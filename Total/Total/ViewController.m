//
//  ViewController.m
//  Total
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 Lnote. All rights reserved.
//

#import "ViewController.h"
#import "ITLockView.h"
#import "FirViewController.h"

@interface ViewController ()
@property (nonatomic,copy)NSString *strPassKey;
@property (nonatomic,assign)NSInteger sp; //解锁次数
@property (nonatomic,retain)NSTimer *timer;//延时30秒解锁
@property (nonatomic,retain)NSTimer *timerShow;//显示时间
@property (nonatomic,assign)NSInteger spTimer;//剩余解锁时间
@property (nonatomic,retain) NSDateFormatter *dateFormatter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].statusBarHidden=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePass:) name:@"mima" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJieSuo:) name:@"jiesuo" object:nil];
    
    NSLog(@"%@",NSHomeDirectory());
  
    _sp=5;
  
    
    self.dateFormatter=[[[NSDateFormatter alloc]init]autorelease];
    [_dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    [self initUI];
    
    
    

}
- (void)initUI{
    self.passLabel.textAlignment=NSTextAlignmentCenter;
    self.passLabel.layer.cornerRadius=5;
    self.passLabel.clipsToBounds=YES;
    self.saveBtn.layer.cornerRadius=5;
    self.saveBtn.clipsToBounds=YES;
    self.sureBtn.layer.cornerRadius=5;
    self.sureBtn.clipsToBounds=YES;
    self.sureBtn.hidden=YES;
    self.timeLabel.layer.cornerRadius=5;
    self.timeLabel.clipsToBounds=YES;


}
- (IBAction)goSaveBtn:(UIButton *)sender {
    if (self.strPassKey.length>0) {
        
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
    if (str==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_strPassKey forKey:@"key"];
        NSLog(@"密码已经成功保存,请牢记");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"密码已经成功保存,请牢记" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];

        
        
        
    }else{
        NSLog(@"本次密码不能保存,原因是主人之前已经保存过密码了");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"本次密码不能保存,原因是主人之前已经保存过密码了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
        self.passLabel.text=@"请输入密码(解锁图案)";
    
    }else{
    
        NSLog(@"请输入要保存的密码");
        self.passLabel.text=@"请输入要保存的密码";
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入要保存的密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    
    
    }
    
    _strPassKey=nil;
   
    
}
- (void)receivePass:(NSNotification *)sender{
    
    if (_sp>0) {
        self.strPassKey=sender.userInfo[@"key"];
        self.passLabel.text=self.strPassKey;
    }
 
   


}
- (void)timered{
    _spTimer=_spTimer-1;
    self.passLabel.text=[NSString stringWithFormat:@"剩余 %ld 秒后才能继续解锁",_spTimer];
    if (_spTimer==0) {
        [_timer setFireDate:[NSDate distantFuture]];
        _sp=5;
        self.passLabel.text=@"请输入密码(解锁图案)";
    }



}
- (void)receiveJieSuo:(NSNotification *)sender{

    NSLog(@"解锁了..");
    NSString *strLocal=[[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
    if (strLocal==nil) {
        
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"警告" message:@"由于您没有设置锁屏密码，这样可能造成个人数据泄露(点击确定停留在当前页面,点击取消直接则跳过当前页面)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:sure];
        
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            FirViewController *fVC=[[FirViewController new]autorelease];
            
            
            [self.navigationController pushViewController:fVC animated:YES];
            
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    
    if (_strPassKey.length>0&&_sp>0&&strLocal!=nil) {
        //取出本地密码
        
        if ([_strPassKey isEqualToString:strLocal]) {
            NSLog(@"123");
            FirViewController *fVC=[[FirViewController new]autorelease];
            
            CATransition *animation=[CATransition animation];
            animation.duration=2;
            animation.type=@"suckEffect";
            [self.view.window.layer addAnimation:animation forKey:nil];
            
            _sp=5;
            _strPassKey=nil;
            strLocal=nil;
            self.passLabel.text=nil;
            [self.navigationController pushViewController:fVC animated:YES];
            
            
        }else{
            _sp=_sp-1;
            self.passLabel.text=[NSString stringWithFormat:@"密码不正确请重试,剩余 %ld 次",_sp];
            self.passLabel.textAlignment=NSTextAlignmentCenter;
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:self.passLabel.text preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self performSelector:@selector(timedShowed) withObject:nil afterDelay:3];
                if (_sp==0) {
                    [_timer setFireDate:[NSDate distantPast]];
                    _spTimer=30;
                }
                
                
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            _strPassKey=nil;
            
            
        }
        
        
        
        
        
        
    }else{
        
        if (_sp>0&&strLocal.length>0) {
            NSLog(@"请输入密码(解锁图案)");
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码(解锁图案)" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
        
        
    }
    
    
    






}

- (IBAction)goNextBtn:(UIButton *)sender {
//     NSString *strLocal=[[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
//    if (strLocal==nil) {
//        
//       
//        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"警告" message:@"由于您没有设置锁屏密码，这样可能造成个人数据泄露(点击确定停留在当前页面,点击取消直接则跳过当前页面)" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//        }];
//        [alert addAction:sure];
//        
//        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            FirViewController *fVC=[[FirViewController new]autorelease];
//            
//            
//            [self.navigationController pushViewController:fVC animated:YES];
//            
//        }];
//        [alert addAction:cancel];
//    
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }
//    
//    
//
//    if (_strPassKey.length>0&&_sp>0&&strLocal!=nil) {
//        //取出本地密码
//       
//            if ([_strPassKey isEqualToString:strLocal]) {
//            NSLog(@"123");
//            FirViewController *fVC=[[FirViewController new]autorelease];
//                
//                CATransition *animation=[CATransition animation];
//                animation.duration=2;
//                animation.type=@"suckEffect";
//                [self.view.window.layer addAnimation:animation forKey:nil];
//                
//                _sp=5;
//                _strPassKey=nil;
//                strLocal=nil;
//                self.passLabel.text=nil;
//            [self.navigationController pushViewController:fVC animated:YES];
//            
//            
//            }else{
//                _sp=_sp-1;
//            self.passLabel.text=[NSString stringWithFormat:@"密码不正确请重试,剩余 %ld 次",_sp];
//            self.passLabel.textAlignment=NSTextAlignmentCenter;
//               
//                
//                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:self.passLabel.text preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                     [self performSelector:@selector(timedShowed) withObject:nil afterDelay:3];
//                    if (_sp==0) {
//                        [_timer setFireDate:[NSDate distantPast]];
//                          _spTimer=30;
//                    }
//                    
//                    
//                }];
//                [alert addAction:sure];
//                [self presentViewController:alert animated:YES completion:nil];
//  
//                
//                _strPassKey=nil;
//                
//            
//            }
//        
//        
//        
//        
//        
//        
//    }else{
//    
//        if (_sp>0&&strLocal.length>0) {
//            NSLog(@"请输入密码(解锁图案)");
//            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码(解锁图案)" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                
//            }];
//            [alert addAction:sure];
//            [self presentViewController:alert animated:YES completion:nil];
//            
//          
//        }
//       
//    
//    
//    }
//    
//    
//    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timered) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    _timerShow =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerShowText) userInfo:nil repeats:YES];
    [_timerShow fire];
    
      NSString *strLocal=[[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
    if (strLocal.length>0) {
         self.passLabel.text=@"请输入密码(解锁图案)";
        
    }else{
        self.passLabel.text=@"请先输入密码并保存";
        
      
    
    }
    
    
    

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer=nil;
    [_timerShow invalidate];
    _timerShow=nil;
}
- (void)timerShowText{
    
    NSString *dateStr=[_dateFormatter stringFromDate:[NSDate date]];
    self.timeLabel.text=dateStr;

}
- (void)timedShowed{
    
   self.passLabel.text=@"请输入密码(解锁图案)";

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_passLabel release];
    [_saveBtn release];
    [_sureBtn release];
    [_timeLabel release];
    [super dealloc];
}
@end
