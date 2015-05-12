//
//  ViewController.m
//  PopupViewDemo
//
//  Created by 刘廷勇 on 15/5/12.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ViewController.h"
#import "PopupView.h"

@interface ViewController ()

@property (nonatomic, strong) PopupView *resultView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultView = [[PopupView alloc] initWithArrowPoint:CGPointMake(200, 300) contentSize:CGSizeMake(200, 200) inView:self.view];
    [self.view addSubview:self.resultView];
    self.resultView.backgroundColor = [UIColor blackColor];
    self.resultView.alpha = 0.8;
}

@end
