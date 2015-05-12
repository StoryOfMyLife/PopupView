//
//  PopupView.h
//  YoudaoDict
//
//  Created by 刘廷勇 on 15/5/11.
//  Copyright (c) 2015年 Netease Youdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Sizes.h"

typedef enum : NSUInteger {
    ArrowDirectionUp,
    ArrowDirectionDown,
} ArrowDirection;

@interface PopupView : UIView

/**
 *  PopupView初始化
 *
 *  @param arrowPoint  箭头在view中的位置
 *  @param contentSize 箭头以外区域的大小
 *  @param view        self.superview
 *
 *  @return self
 */
- (instancetype)initWithArrowPoint:(CGPoint)arrowPoint contentSize:(CGSize)contentSize inView:(UIView *)view;

/**
 *  用来添加subviews
 */
@property (nonatomic, strong) UIView *contentView;

@end
