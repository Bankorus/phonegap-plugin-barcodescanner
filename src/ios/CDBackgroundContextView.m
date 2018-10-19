//
//  CDBackgroundContextView.m
//  Bankorus
//
//  Created by Ke Wang on 2018/9/10.
//

#define LineMovingDuration 0.02f


#import "CDBackgroundContextView.h"

@interface CDBackgroundContextView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat lineY;


@end

@implementation CDBackgroundContextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//        self.opaque = NO; // 设置为透明的
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect mainRect = [UIScreen mainScreen].bounds;
    [self addMovingLine:mainRect];
    [self addClearRect:mainRect];
    [self addFourBorder:mainRect];
}


#pragma mark - method

/**
 中间区域透明

 @param mainRect rect
 */
- (void)addClearRect:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    [[UIColor colorWithWhite:0 alpha:0.1] setFill];
    UIRectFill(mainRect);
    CGRect clearRect = CGRectMake(mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3, 2*mainRectWidth/3, 2*mainRectWidth/3);
    CGRect clearIntersection = CGRectIntersection(clearRect, mainRect);
    [[UIColor clearColor] setFill];
    UIRectFill(clearIntersection);
}


/**
 添加4个角线

 @param mainRect rect
 */
- (void)addFourBorder:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width; //!< 375
    CGFloat mainRectHeight = mainRect.size.height; //!< 667
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGPoint upLeftPoints[] = {CGPointMake(mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3), CGPointMake(mainRectWidth/6 + 20, mainRectHeight/2 - 2*mainRectWidth/3), CGPointMake(mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3), CGPointMake(mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3 + 20)};
    CGPoint upRightPoints[] = {CGPointMake(5*mainRectWidth/6 - 20, mainRectHeight/2 - 2*mainRectWidth/3), CGPointMake(5*mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3), CGPointMake(5*mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3), CGPointMake(5*mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3 + 20)};
    CGPoint belowLeftPoints[] = {CGPointMake(mainRectWidth/6, mainRectHeight/2), CGPointMake(mainRectWidth/6, mainRectHeight/2 - 20), CGPointMake(mainRectWidth/6, mainRectHeight/2), CGPointMake(mainRectWidth/6 +20, mainRectHeight/2)};
    CGPoint belowRightPoints[] = {CGPointMake(5*mainRectWidth/6, mainRectHeight/2), CGPointMake(5*mainRectWidth/6 - 20, mainRectHeight/2), CGPointMake(5*mainRectWidth/6, mainRectHeight/2), CGPointMake(5*mainRectWidth/6, mainRectHeight/2 - 20)};
    CGContextStrokeLineSegments(ctx, upLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, upRightPoints, 4);
    CGContextStrokeLineSegments(ctx, belowLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, belowRightPoints, 4);
}


/**
 添加扫描线

 @param mainRect rect
 */
- (void)addMovingLine:(CGRect)mainRect {
    if (!self.lineView) {
        [self initLineView:mainRect];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:LineMovingDuration target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
}


/**
 初始化扫描线

 @param mainRect mainRect
 */
- (void)initLineView:(CGRect)mainRect {
    CGFloat mainRectWith = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(mainRectWith/6, mainRectHeight/2 - 2*mainRectWith/3, 2*mainRectWith/3, 2)];
    self.lineView.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineView];
    self.lineY = self.lineView.frame.origin.y;
}


/**
 做动画
 */
- (void)moveLine {
    [UIView animateWithDuration:LineMovingDuration animations:^{
        CGRect rect = self.lineView.frame;
        rect.origin.y = self.lineY;
        self.lineView.frame = rect;
    } completion:^(BOOL finished) {
        CGRect mainRect = [UIScreen mainScreen].bounds;
        CGFloat mainRectHeight = mainRect.size.height;
        CGFloat mainRectWith = mainRect.size.width;
        CGFloat maxLineY = mainRect.size.height/2;
        if (self.lineY >= maxLineY) {
            self.lineY = mainRectHeight/2 - 2*mainRectWith/3;
        } else {
            self.lineY ++;
        }
    }];
}


@end
