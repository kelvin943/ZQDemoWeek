//
//  PATableViewWithLineCell.m
//  manpanxiang
//
//  Created by Linkou Bian on 25/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PATableViewWithLineCell.h"
#import "UIColor+Category.h"
#import "UIView+PALayoutHelper.h"

#define HEIGHT_OF_LINE (1.0 / [UIScreen mainScreen].scale)

@interface PATableViewWithLineCell ()

@property (nonatomic, strong) UILabel *upLine;
@property (nonatomic, strong) UILabel *bottomLine;

@end

@implementation PATableViewWithLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        _upLine = [[UILabel alloc] init];
        _upLine.backgroundColor = [UIColor colorWithHex:0xE1E1E1];
        [self.contentView addSubview:_upLine];
        
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHex:0xE1E1E1];
        [self.contentView addSubview:_bottomLine];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat offset = self.object.cellLineIndent;
    CGFloat upOffset = 0.0f;
    CGFloat bottomOffset = 0.0f;
    
    CGFloat widthOfApplicationFrame = [[UIScreen mainScreen] applicationFrame].size.width;
    
    switch (self.object.cellPosition) {
        case PACellPositionNone:
            upOffset = bottomOffset = 0.0f;
            break;
            
        case PACellPositionFirst:
            if (self.object.hideUpLineForFirst) {
                upOffset = widthOfApplicationFrame;
            }
            bottomOffset = offset;
            break;
            
        case PACellPositionMiddle:
            upOffset = bottomOffset = offset;
            break;
            
        case PACellPositionLast:
            upOffset = offset;
            if (self.object.hideDownLineForLast) {
                bottomOffset = widthOfApplicationFrame;
            }
            break;
            
        case PACellPositionOnly:
            if (self.object.hideUpLineForFirst) {
                upOffset = widthOfApplicationFrame;
            }
            if (self.object.hideDownLineForLast) {
                bottomOffset = widthOfApplicationFrame;
            }
            break;
            
        default:
            break;
    }
    
    _upLine.frame = CGRectMake(upOffset, 0, self.width, HEIGHT_OF_LINE);
    _bottomLine.frame = CGRectMake(bottomOffset, self.height, self.width, HEIGHT_OF_LINE);
}

@end
