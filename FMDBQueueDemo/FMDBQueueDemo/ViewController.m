//
//  ViewController.m
//  FMDBQueueDemo
//
//  Created by student on 16/3/23.
//  Copyright © 2016年 student. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import <mach/mach_time.h>


//1.在使用FMDatabase时同时多个操作需要加锁，否则会有操作不成功

//2.FMDB提供的FMDatabaseQueue这个类的用法,inDatabase和inTransaction方法的使用
//  第一步：初始化FMDatabaseQueue对象，并加入数据库路径
//  第二步：使用inDatabase方法创建表
//  第三步：使用inDatabase或者inTransaction方法对数据库进行增删改查操作

//3.用FMDatabaseQueue的四种方式比较插入500条数据的耗时


@interface ViewController ()


@property (nonatomic, retain) NSLock *lock;//全局lock锁属性

@property (nonatomic, retain) FMDatabase *mydb;//用于FMDatabase创建数据库的对象属性

@property (nonatomic, retain) FMDatabaseQueue *queue;//用于使用FMDatabaseQueue创建数据库的对象属性

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*********************原始方法创建数据库******************************/
    //原始方法只是用来作比较，因此没有写注释
    self.lock = [[NSLock alloc] init];
    
    self.mydb = [FMDatabase databaseWithPath:[self getFilePath]];
    
    if ([self.mydb open]) {
        
        NSLog(@"open success");
        
        BOOL result = [self.mydb executeUpdate:@"CREATE TABLE IF NOT EXISTS stu (id integer PRIMARY KEY AUTOINCREMENT,name text,age integer)"];
        
        if (result) {
            NSLog(@"create success");
        }else{
            NSLog(@"create failure");
        }
     
        [self.mydb close];
        
    }else{
        
        NSLog(@"open failure");
        
    }

    /*********************FMDBQueue创建数据库******************************/
    //创建数据库并加入队列，此时默认已经打开了数据库，无须手动打开，只需要从队列中去取数据库即可
    self.queue = [FMDatabaseQueue databaseQueueWithPath:[self getFilePath]];
    
    //下面取出数据库，在数据库中创建表
    //- (void)inDatabase:(void (^)(FMDatabase *db))block 
    //调用该方法，FMDatabaseQueue类的方法，参数db为Queue自动创建好的数据库。
    //在block体中进行数据的增删改查
    //我们无需手动对数据库进行open和close操作，Queue已经自动帮我们管理好了。
    [self.queue inDatabase:^(FMDatabase *db) {//db就是你前面加入队列的数据库
        
        //创建表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (id integer PRIMARY KEY AUTOINCREMENT,name text,age integer)"];

        if (result) {
            NSLog(@"create success");
        }else{
            NSLog(@"create failure");
        }
    }];
}


#pragma mark - 获取数据库路径
- (NSString *)getFilePath {
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myfmdb.sqlite"];
    
    NSLog(@"%@",filePath);
    
    return filePath;
}




#pragma mark - NSLock
#pragma mark 插入
- (IBAction)insert:(id)sender {
    
    [self.mydb open];
    NSDate *date1 = [NSDate date];

    for (NSInteger i = 0; i < 500; i++) {
        
        [self.lock lock];
        
        NSString *name = [NSString stringWithFormat:@"SomeBody%d",arc4random()%100];
        
        NSNumber *age = @(arc4random()%100);
         
        [self.mydb executeUpdate:@"INSERT INTO stu(name,age) VALUES(?,?)",name,age];
        
        [self.lock unlock];
    }
    
    NSLog(@"NSLock锁插入五百条数据成功");
    
    [self.mydb close];
    
    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"不使用事务插入500条数据用时%.3f秒",a);
}

#pragma mark 删除
- (IBAction)delete:(id)sender {
    
    [self.lock lock];
    [self.mydb open];
    
    
    [self.mydb executeUpdate:@"DELETE FROM stu WHERE id=?",@10];
    
    
    NSLog(@"NSLock锁删除一条数据成功");

    [self.mydb close];
    
    [self.lock unlock];
}


#pragma mark 更新
- (IBAction)update:(id)sender {
    [self.mydb open];
    [self.lock lock];
    
    [self.mydb executeUpdate:@"UPDATE stu SET name='ABcd' WHERE id=?",@11];
    NSLog(@"NSLock锁更新一条数据成功");
    
    [self.lock unlock];
    [self.mydb close];
    
}


#pragma mark 选择
- (IBAction)select:(id)sender {
    [self.mydb open];
    [self.lock lock];
    FMResultSet *set = [self.mydb executeQuery:@"SELECT * FROM stu WHERE age>?",@50];
    
    while ([set next]) {
        
        int ID = [set intForColumn:@"id"];
        int age = [set intForColumn:@"age"];
        NSString *name = [set stringForColumn:@"name"];
        
        NSLog(@"id:%d, name:%@, age:%d",ID,name,age);
    }
    [self.lock unlock];
    [self.mydb close];
}


#pragma mark NSLock锁同时删除和更新一条数据
#warning 提示，同时操作时，可以尝试不加锁，看是否能完成多条操作
- (IBAction)combin:(id)sender {
    
//    dispatch_queue_t queue = dispatch_queue_create([@"FMDBQueue" cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
    
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个组队列用以模拟同时进行删除和更新操作
    dispatch_group_t group = dispatch_group_create();
    
    //创建一个组队列的异步请求用于删除操作
    dispatch_group_async(group, queue, ^{
        
        [self delete:nil];
    });
    
    //创建一个组队列的异步请求用于更新操作
    dispatch_group_async(group, queue, ^{
        
        [self update:nil];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        NSLog(@"同时删除和更新一条数据完成");
        
    });
    
}


- (void)profileDoSomething
{
//    uint64_t begin = mach_absolute_time();
//    uint64_t end = mach_absolute_time();
//    NSLog(@"Time taken to doSomething %g s",
//          MachTimeToSecs(end - begin));
}



#pragma mark - Queue
#pragma mark 插入

- (IBAction)insertWithQueue:(id)sender {

    
    
    
    //记录开始时间
    NSDate *date1 = [NSDate date];
    
    uint64_t begin = mach_absolute_time();

    //使用inDatabase方法插入数据
    [self.queue inDatabase:^(FMDatabase *db) {
        
        //插入五百条数据
        for (NSInteger i = 0; i < 500; i++) {
            
            //模拟数据
            NSString *name = [NSString stringWithFormat:@"SomeBody%d",arc4random()%100];
            
            NSNumber *age = @(arc4random()%100);
            
            //该方法插入数据，与使用FMDBQueue一样
            [db executeUpdate:@"INSERT INTO student(name,age) VALUES(?,?)",name,age];
        }

    }];
    //记录结束时间
    NSDate *date2 = [NSDate date];
    uint64_t end = mach_absolute_time();
    //计算耗时
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"不使用事务插入500条数据用时%.3f秒",a);
    NSLog(@"Time taken to doSomething %g s",
          MachTimeToSecs(end - begin));
}


double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom /1e9;
}


#pragma mark 删除
- (IBAction)deleteWithQueue:(id)sender {
    //删除与更新操作只是演示inDatabase的用法
    [self.queue inDatabase:^(FMDatabase *db) {
            [self.mydb executeUpdate:@"DELETE FROM student WHERE id=?",@10];
    }];
}


#pragma mark 更新
- (IBAction)updateWithQueue:(id)sender {
    [self.queue inDatabase:^(FMDatabase *db) {
         [self.mydb executeUpdate:@"UPDATE student SET name='ABcd' WHERE id=?",@11];
    }];
}


#pragma mark 创建500条并行队列插入数据
- (IBAction)globalInsertWithQueue:(id)sender {

    
    NSDate *date1 = [NSDate date];

    //for循环创建500条并行队列
    for (NSInteger i = 0; i < 500; i++) {
        //并行队列
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //inDatabase方法插入数据
            [self.queue inDatabase:^(FMDatabase *db) {
                
                //模拟数据
                NSString *name = [NSString stringWithFormat:@"SomeBody%d",arc4random()%100];

                NSNumber *age = @(arc4random()%100);

                //插入数据
                [db executeUpdate:@"INSERT INTO student(name,age) VALUES(?,?)",name,age];

            }];
        });
    }

    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"使用多线程插入500条数据用时%.3f秒",a);
}


#pragma mark 使用事务插入数据
- (IBAction)transactionInsertWithQueue:(id)sender {

    NSDate *date1 = [NSDate date];

    //事务操作
    //- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
    //使用事务插入方法，FMDatabaseQueue的方法。
    //当需要对数据库两个操作以上时候，可以使用该方法，操作越多效果越明显
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        //在inTransaction方法中插入500数据
        for (NSInteger i = 0; i < 500; i++) {

            //模拟数据
            NSString *name = [NSString stringWithFormat:@"SomeBody%d",arc4random()%100];

            NSNumber *age = @(arc4random()%100);
            
            //插入数据
            [db executeUpdate:@"INSERT INTO student(name,age) VALUES(?,?)",name,age];
        }
    }];
    
    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"使用事务插入500条数据用时%.3f秒",a);
    
}


#pragma mark 同时使用并行队列和事务插入
- (IBAction)transactionAndGlobalInsert:(id)sender {
    
    
    uint64_t begin = mach_absolute_time();
    NSDate *date1 = [NSDate date];
    
    for (NSInteger i = 0; i < 5; i++) {
        
        //创建五个并行队列
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            //每个并行队列中添加一个事务方法
            [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                //每隔事务中插入100条数据
                for (NSInteger j = 0; j < 100; j++) {
                    
                    //模拟数据
                    NSString *name = [NSString stringWithFormat:@"SomeBody%d",arc4random()%100];
                    
                    NSNumber *age = @(arc4random()%100);
                    
                    //插入数据
                    [db executeUpdate:@"INSERT INTO student(name,age) VALUES(?,?)",name,age];
                }
            }];
        });
    }
    uint64_t end = mach_absolute_time();

    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"使用事务插入500条数据用时%f秒",a);
    NSLog(@"Time taken to doSomething %g s",
          MachTimeToSecs(end - begin));
}


@end
