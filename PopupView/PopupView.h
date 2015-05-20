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
 *  PopupView Convenient Initializer
 *
 *  @param arrowPoint  箭头在view中的位置
 *  @param contentSize 箭头以外区域的大小
 *  @param view        self.superview
 *
 *  @return PopupView
 */
- (instancetype)initWithArrowPoint:(CGPoint)arrowPoint contentSize:(CGSize)contentSize inView:(UIView *)view;

/**
 *  PopupView Convenient Initializer
 *
 *  @param arrowPoint  箭头在view中的位置
 *  @param offset      整体在Y方向的偏移, offset > 0 表示整体远离arrowPoint, offset < 0 表示相反
 *  @param contentSize 箭头以外区域的大小
 *  @param view        self.superview
 *
 *  @return PopupView
 */
- (instancetype)initWithArrowPoint:(CGPoint)arrowPoint arrowOffset:(CGFloat)offset contentSize:(CGSize)contentSize inView:(UIView *)view;

/**
 *  用来添加subviews
 */
@property (nonatomic, strong) UIView *contentView;

@end
