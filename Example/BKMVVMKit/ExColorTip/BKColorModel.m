//
//  BKColorModel.m
//  Pods
//
//  Created by lic on 2019/9/6.
//

#import "BKColorModel.h"

@implementation BKColorModel

- (instancetype)initTitle:(NSString *)title isSelected:(BOOL)selected {
    if (self = [super init]) {
        _colorName = title;
        _isSelected = selected;
    }
    return self;
}
@end
