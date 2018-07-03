//
//  PADragRefreshImageView.m
//  haofang
//
//  Created by Steven.Lin on 6/4/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PADragRefreshImageView.h"
#import "UIColor+Category.h"

@interface PADragRefreshImageView ()

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIImageView* loadingView;
@property (assign, nonatomic) CAShapeLayer* circleLayer;

@end


@implementation PADragRefreshImageView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self initContentView:frame];
    }
    
    return self;
}

- (void)initContentView:(CGRect)frame {
    UIImage* imageHouse = [UIImage imageNamed:@"IconLoadingHouse"];
    CGSize size = imageHouse.size;
    
    _imageView = [[UIImageView alloc] initWithImage:imageHouse];
    _imageView.frame = CGRectMake((frame.size.width - size.width) / 2, (frame.size.height - size.height) / 2, size.width, size.height);
    
    [self addSubview:_imageView];
    
    UIImage* imageLoading = [UIImage imageNamed:@"Iconloading"];
    size = imageLoading.size;
    
    _loadingView = [[UIImageView alloc] initWithImage:imageLoading];
    [self addSubview:_loadingView];
    _loadingView.frame = CGRectMake((frame.size.width - size.width) / 2, (frame.size.height - size.height) / 2, size.width, size.height);
    _loadingView.alpha = 0.0;
    
    // 增加一个开闭的圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:_loadingView.frame];
    self.circleLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:self.circleLayer];
    
}

#pragma mark - Public Methods

- (void)startRotateAnimation
{
    _loadingView.alpha = 1.0;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.duration = 0.6f;
    animation.repeatCount = INT_MAX;
    animation.delegate = self.delegate;
    
    [_loadingView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

- (void)stopRotateAnimation
{
    [_loadingView.layer removeAllAnimations];
    _loadingView.alpha = 0.0;
}

#pragma mark - Property Methods

- (CAShapeLayer *)circleLayer {
    if (nil == _circleLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [UIColor colorWithHex:0xcccccc].CGColor;
        shapeLayer.lineWidth = 2.5;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeEnd = 0.0f;
        shapeLayer.strokeStart = 0.0f;
        
        self.circleLayer = shapeLayer;
    }
    return _circleLayer;
}

- (void)setPullOffset:(CGFloat)pullOffset {
    if (!self.isLoading) {
        self.circleLayer.hidden = NO;
        CGFloat ratio = fabs(pullOffset)/65.0f;
        self.circleLayer.strokeStart = 0.f;
        self.circleLayer.strokeEnd = ratio;
    } else {
        self.circleLayer.hidden = YES;
        self.circleLayer.strokeEnd = 0.0f;
    }
}

- (void) setStatus:(PATableRefreshStatus)status {
    _imageView.hidden = NO;
    
    switch (status) {
        case PATableRefreshStatusLoading:
            _loadingView.hidden = NO;
            [self startRotateAnimation];
            break;
        case PATableRefreshStatusPullToReload:
            _loadingView.hidden = YES;
            break;
        case PATableRefreshStatusReleaseToReload:
            _loadingView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
