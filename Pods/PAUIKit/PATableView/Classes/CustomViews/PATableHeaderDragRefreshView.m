//
//  PATableHeaderDragRefreshView.m
//  haofang
//
//  Created by PengFeiMeng on 4/1/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PATableHeaderDragRefreshView.h"
#import "PADragRefreshImageView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@interface PATableHeaderDragRefreshView ()

@property (nonatomic, retain) PADragRefreshImageView *refreshImageView;  // 下拉时候显示的图片
@property (nonatomic, assign) BOOL                   hasOverride;

@end

@implementation PATableHeaderDragRefreshView
{
    PAPullRefreshState _state;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.refreshImageView];
    }
    
    return self;
}

- (void)setState:(PAPullRefreshState)aState {
    _refreshImageView.isLoading = NO;
	switch (aState) {
        case PAPullRefreshPulling:
			break;
		case PAPullRefreshNormal:
            [_refreshImageView stopRotateAnimation];
			break;
		case PAPullRefreshLoading:
            _refreshImageView.isLoading = YES;
            [_refreshImageView startRotateAnimation];
			break;
		default:
			break;
	}
    
	_state = aState;
    
}

#pragma mark scroll callback

- (void)paRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
    _refreshImageView.pullOffset = scrollView.contentOffset.y;
	if (_state == PAPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(paRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate paRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == PAPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:PAPullRefreshNormal];
		} else if (_state == PAPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:PAPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)paRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(paRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate paRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([self.delegate respondsToSelector:@selector(paRefreshTableHeaderDidTriggerRefresh:)]) {
			[self.delegate paRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:PAPullRefreshLoading];
        
        // iOS 8-10，下拉松开之后 scrollView 本身的 bounce 效果与设置的 inset 冲突，导致 contentOffset 先下移一段距离
        // 参考阿里工程师的解决办法，用 setContentOffset:animated: 而不是直接使用属性赋值
        // https://blog.cnbluebox.com/blog/2015/01/19/shake-in-pull-to-refresh/
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                UIEdgeInsets inset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                scrollView.contentInset = inset;
                [scrollView setContentOffset:CGPointMake(0, -inset.top) animated:NO];
            } completion:^(BOOL finished) {
            }];
        });
	}
	
}

- (void)paRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.2];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:PAPullRefreshNormal];
    
}

#pragma mark - CAAnimation Nullable Delegate, Prevent Animation Stop while Task have not completed

// 弱网情况下， 下拉动画停止的修复
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (!flag && (_state == PAPullRefreshPulling || _state == PAPullRefreshLoading )) {
        [_refreshImageView startRotateAnimation];
    }

}

-(void)animationDidStart:(CAAnimation *)anim{

}

#pragma mark - Property Methods

- (PADragRefreshImageView *)refreshImageView {
    if (_refreshImageView == nil) {
        _refreshImageView = [[PADragRefreshImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 60.0f)];
        _refreshImageView.delegate = self;
    }
    
    CGRect frame = _refreshImageView.frame;
    frame.origin.x = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
    frame.origin.y = (self.frame.size.height - frame.size.height);
    _refreshImageView.frame = frame;
    
    return _refreshImageView;
    
}

@end
