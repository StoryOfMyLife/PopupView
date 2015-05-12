//
//  PopupView.m
//  YoudaoDict
//
//  Created by 刘廷勇 on 15/5/11.
//  Copyright (c) 2015年 Netease Youdao. All rights reserved.
//

#import "PopupView.h"

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 3.f

static const CGFloat kArrowHeight = 10.0f;
static const CGFloat cornerRadius = 5.0f;

static const CGFloat borderGap = 10;
static const CGFloat arrowGap = cornerRadius + kArrowHeight/2;

@interface PopupView ()

@property (nonatomic, strong) CAShapeLayer *mask;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic) CGFloat arrowOffsetX;

@property (nonatomic) ArrowDirection direction;

@end

@implementation PopupView

- (instancetype)initWithArrowPoint:(CGPoint)arrowPoint contentSize:(CGSize)contentSize inView:(UIView *)view
{
    //限定宽度
    CGFloat width = MIN(view.width - borderGap * 2, contentSize.width);
    //限定高度不能超过一半
    CGFloat height = MIN(view.height / 2, contentSize.height + kArrowHeight);
    
    //限定arrow的范围
    arrowPoint.x = MAX(arrowGap, MIN(arrowPoint.x, view.width - arrowGap));//x限定在左右arrowGap内
    arrowPoint.y = MAX(0, MIN(arrowPoint.y, view.height));//y限定在view内
    
    //尽量显示在靠中间位置
    CGFloat x = 0;
    
    if (arrowPoint.x <= view.width / 2) {
        x = MAX(0, MIN(arrowPoint.x - arrowGap, (view.width - width) / 2));
    } else {
        x = MIN(view.width - width, MAX(arrowPoint.x + arrowGap - width, (view.width - width) / 2));
    }
    
    if (arrowPoint.y <= view.height/2) {
        self = [self initWithFrame:CGRectMake(x, arrowPoint.y, width, height)];
        self.direction = ArrowDirectionUp;
    } else {
        self = [self initWithFrame:CGRectMake(x, arrowPoint.y - height, width, height)];
        self.direction = ArrowDirectionDown;
    }
    self.arrowOffsetX = arrowPoint.x - x;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = cornerRadius;
        
        self.mask = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:self.mask];
        
        self.arrowOffsetX = self.width/2;
        self.direction = ArrowDirectionUp;
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.mask.fillColor = backgroundColor.CGColor;
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:self.mask.fillColor];
}

- (void)setDirection:(ArrowDirection)direction
{
    _direction = direction;
    CGRect frame = CGRectMake(0, 0, self.width, self.height - kArrowHeight);
    if (_direction == ArrowDirectionUp) {
        frame.origin.y = kArrowHeight;
    }
    self.contentView.frame = frame;
}

- (void)setArrowOffsetX:(CGFloat)arrowOffsetX
{
    if (_arrowOffsetX != arrowOffsetX) {
        CGFloat gap = self.layer.cornerRadius;
        _arrowOffsetX = MAX(kArrowHeight + gap, MIN(arrowOffsetX, self.width - kArrowHeight - gap));
    }
}

- (void)setupMaskPath
{
    /*
        LT2           RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
        |               |
        |    popover    |
        |               |
     LB2⌞_______________⌟RB1
        LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    CGFloat xMin = 0;
    CGFloat yMin = 0;
    
    CGFloat xMax = self.width;
    CGFloat yMax = self.height - kArrowHeight;
    
    CGPoint arrowPoint = CGPointMake(self.arrowOffsetX, self.height);
    
    if (self.direction == ArrowDirectionUp) {
        yMin = kArrowHeight;
        yMax = self.height;
        arrowPoint = CGPointMake(self.arrowOffsetX, 0);
    }
    
    CGFloat radius = self.layer.cornerRadius;
    
    self.mask.frame = self.bounds;
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    
    //LT1->LT2
    [popoverPath moveToPoint:CGPointMake(xMin, yMin + radius)];//LT1
    [popoverPath addQuadCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint:CGPointMake(xMin, yMin)];//LT2
    
    if (self.direction == ArrowDirectionUp) {
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin) controlPoint2:arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    }
    
    //RT1->RT2
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addQuadCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint:CGPointMake(xMax, yMin)];//RT2
    
    //RB1->RB2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addQuadCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint:CGPointMake(xMax, yMax)];//RB2
    
    if (self.direction == ArrowDirectionDown) {
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMax)];//right side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMax) controlPoint2:arrowPoint];//arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMax) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMax)];
    }
    
    //LB1->LB2
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addQuadCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint:CGPointMake(xMin, yMax)];//LB2
    
    //LB2->LT1
    [popoverPath closePath];
    
    self.mask.path = popoverPath.CGPath;
}

- (void)layoutSubviews
{
    [self setupMaskPath];
}

@end
