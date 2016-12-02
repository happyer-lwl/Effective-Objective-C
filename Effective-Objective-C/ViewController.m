//
//  ViewController.m
//  Effective-Objective-C
//
//  Created by WyzcWin on 16/12/2.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

static void * kAlertBlockKey = @"AlertBlockKey";

@interface ViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 关联对象
    [self.view addSubview:self.titleLabel];
    [_titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    // Method Swizzling 黑魔法
    Method methodNormal = class_getInstanceMethod([self class], @selector(showNormalLog));
    Method methodUnNormal = class_getInstanceMethod([self class], @selector(showUnNormalLog));
    method_exchangeImplementations(methodNormal, methodUnNormal);
}

#pragma mark - 关联对象
/**
 KVO  监听Label

 @param keyPath 监听key
 @param object  监听对象
 @param change  变化内容
 @param context 选填参数
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == _titleLabel && [keyPath isEqualToString:@"text"]) {
        
        NSString *str = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"New Label1 Str: %@", str);
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 375, 50.0f)];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^alertBlock)(NSInteger) = objc_getAssociatedObject(alertView, kAlertBlockKey);
    if (alertBlock) {
        alertBlock(buttonIndex);
    }
}

#pragma mark - Method Swizzling
- (void)showNormalLog{
    NSLog(@"Normal");
}

- (void)showUnNormalLog{
    NSLog(@"Un   Normal");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 关联对象
    static NSInteger count = 0;
    count++;
    
    _titleLabel.text = [NSString stringWithFormat:@"Count Num: %ld", (long)count];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"关联对象" message:@"添加一个Block" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    // 处理回调
    void (^touchAlertBlock)(NSInteger) = ^(NSInteger index) {
        if (index == 0) {
            NSLog(@"0");
        }else{
            NSLog(@"other");
        }
    };
    
    objc_setAssociatedObject(alertView, kAlertBlockKey, touchAlertBlock, OBJC_ASSOCIATION_COPY);
    
    [alertView show];
    
    // 黑马发 Method swizzling
    if (count < 10) {
        [self showNormalLog];
    }else{
        [self showUnNormalLog];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
