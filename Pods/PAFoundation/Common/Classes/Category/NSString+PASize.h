//
//  NSString+PASize.h
//  PAFoundation
//
//  Created by 董天天(外包) on 2017/12/26.
//

#import <Foundation/Foundation.h>

@interface NSString (PASize)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
