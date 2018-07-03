//
//  PANoticeUtil.m
//  haofang
//
//  Created by shakespeare on 14-4-22.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "PANoticeUtil.h"

static BOOL hudShown = NO;
static UIView *hudView = nil;

@implementation PANoticeUtil

#pragma mark - Public Methods

+ (void)showNotice:(NSString *)text {
    if ([text length] == 0) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showNotice:text inView:window];
}

+ (void)showNotice:(NSString *)text inView:(UIView *)view {
    
    // 默认显示秒数
    NSTimeInterval duration         = 1.382;
    
    if (text.length > 13) duration  = 2.236;
    else if (text.length > 8) duration = 1.618;
    
    [self showNotice:text inView:view duration:duration completion:nil];
}

+ (void)showNotice:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration {
    [self showNotice:text inView:view duration:duration completion:nil];
}

+ (void)showNotice:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration completion:(void(^)(void))completion {
    // clear old toastview
    if (hudView.superview) {
        [hudView.layer removeAllAnimations];
        [hudView removeFromSuperview];
        hudView = nil;
    };
    
    // content label
    UILabel *contentLabel           = [[UILabel alloc] init];
    contentLabel.numberOfLines      = 0;
    contentLabel.textAlignment      = NSTextAlignmentCenter;
    contentLabel.backgroundColor    = [UIColor clearColor];
    contentLabel.textColor          = [UIColor whiteColor];
    contentLabel.text               = text;
    contentLabel.font               = [UIFont systemFontOfSize:15.0];
    
    // content label frame
    CGSize maxsize                  = CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width - 48, 600);
    CGFloat minWidth                = 88.0;
    NSDictionary *attdic            = @{NSFontAttributeName: contentLabel.font};
    CGSize textSize = [text boundingRectWithSize:maxsize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attdic context:nil].size;

    if (textSize.width < minWidth) {
        textSize.width = minWidth;
    }
    
    contentLabel.frame              = CGRectMake(0, 0, textSize.width, textSize.height);
    
    // hudView
    hudView                         = [[UIView alloc] init];
    hudView.backgroundColor         = [UIColor blackColor];
    hudView.layer.cornerRadius      = 5;
    hudView.layer.opacity           = 0;
    
    // hudView frame
    CGFloat horizontalMargin        = 16;
    CGFloat verticalMargin          = 10;
    CGSize hudViewSize              = CGSizeMake(contentLabel.bounds.size.width + horizontalMargin * 2,
                                                 contentLabel.bounds.size.height + verticalMargin * 2);
    
    CGPoint hudViewCenter           = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    hudView.frame       = CGRectMake(0, 0, hudViewSize.width, hudViewSize.height);
    hudView.center      = hudViewCenter;
    contentLabel.center = CGPointMake(hudView.bounds.size.width / 2, hudView.bounds.size.height / 2);
    
    // addSubview
    [hudView addSubview:contentLabel];
    [view addSubview:hudView];
    [view bringSubviewToFront:hudView];
    
    // show animation
    hudView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    hudShown = YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        hudView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        hudView.layer.opacity       = 0.9;
    } completion:^(BOOL finished) {

        if (!finished) return;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            hudView.transform       = CGAffineTransformMakeScale(1, 1);
            [hudView.layer setOpacity:0.8];
        } completion:^(BOOL finished) {
            
            if (!finished) return;
            
            [UIView animateWithDuration:0.3 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                hudView.transform   = CGAffineTransformMakeScale(0.001, 0.001);
                hudView.layer.opacity   = 0.0;
            } completion:^(BOOL finished) {
                
                if (!finished) return;
                
                if (completion) completion();
                
                [hudView removeFromSuperview];
                hudView             = nil;
                hudShown            = NO;
            }];
        }];
    }];
}

+ (void)hideNotice {
    if (!hudView.superview) return;
    
    [UIView animateWithDuration:0.236 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        hudView.transform           = CGAffineTransformMakeScale(0.001, 0.001);
        [hudView.layer setOpacity:0.0];
    }
    completion:^(BOOL finished) {
        [hudView removeFromSuperview];
        hudView                     = nil;
        hudShown                    = NO;
    }];
}

@end
