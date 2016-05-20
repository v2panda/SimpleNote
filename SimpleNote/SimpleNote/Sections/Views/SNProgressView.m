//
//  SNProgressView.m
//  SimpleNote
//
//  Created by Panda on 16/5/20.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNProgressView.h"

@interface SNProgressView ()

@property (nonatomic, assign) CGRect circlesSize;

@end

@implementation SNProgressView

+(instancetype)viewWithFrame:(CGRect)frame circlesSize:(CGRect)size{
    return [[self alloc] initWithFrame:frame circlesSize:size];
}

- (instancetype)initWithFrame:(CGRect)frame circlesSize:(CGRect)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circlesSize = size;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self addBackCircleWithSize:self.circlesSize.origin.x lineWidth:self.circlesSize.origin.y];
    [self addForeCircleWidthSize:self.circlesSize.size.width lineWidth:self.circlesSize.size.height];
}

//添加背景的圆环
-(void)addBackCircleWithSize:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    self.backCircle = [self createShapeLayerWithSize:radius lineWith:lineWidth color:[UIColor grayColor]];
    self.backCircle.strokeStart = 0;
    self.backCircle.strokeEnd = 1;
    self.backCircle.strokeColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.3].CGColor;
    [self.layer addSublayer:self.backCircle];
}

//前面的圆环
-(void)addForeCircleWidthSize:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    self.foreCircle = [self createShapeLayerWithSize:radius lineWith:lineWidth color:[UIColor greenColor]];
    
    self.foreCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                          radius:radius-lineWidth/2
                                                      startAngle:-M_PI/2
                                                        endAngle:M_PI/180*270
                                                       clockwise:YES].CGPath;
    self.foreCircle.strokeStart = 0;
    self.foreCircle.strokeEnd = 0.8;
    self.foreCircle.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.foreCircle];
}

//创建圆环
-(CAShapeLayer *)createShapeLayerWithSize:(CGFloat)radius lineWith:(CGFloat)lineWidth color:(UIColor *)color{
    CGRect foreCircle_frame = CGRectMake(self.bounds.size.width/2-radius,
                                         self.bounds.size.height/2-radius,
                                         radius*2,
                                         radius*2);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = foreCircle_frame;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                        radius:radius-lineWidth/2
                                                    startAngle:0
                                                      endAngle:M_PI*2
                                                     clockwise:YES];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.lineCap = @"round";
    
    return layer;
}

-(void)setProgressValue:(CGFloat)progressValue{
    if (self.foreCircle) {
        self.foreCircle.strokeEnd = progressValue;
    }
}



@end
