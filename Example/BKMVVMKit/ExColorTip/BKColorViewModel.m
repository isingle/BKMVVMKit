//
//  BKColorViewModel.m
//  Pods
//
//  Created by lic on 2019/9/6.
//

#import "BKColorViewModel.h"
#import "BKColorModel.h"

@interface BKColorViewModel ()
@property (nonatomic, strong) BKColorModel *model;

@end

@implementation BKColorViewModel

- (instancetype)init {
    if ([super init]) {
        self.model = [[BKColorModel alloc] init];
    }
    return self;
}

- (void)setCurColorName:(NSString *)curColorName {
    _curColorName = curColorName;
}

- (UIColor *)bgColor {
    UIColor *bg;
    if ([self.curColorName containsString:@"red"]) {
        bg = [UIColor redColor];
    } else if ([self.curColorName containsString:@"yellow"]) {
        bg = [UIColor yellowColor];
    } else if ([self.curColorName containsString:@"blue"]) {
        bg = [UIColor blueColor];
    } else if ([self.curColorName containsString:@"gray"]) {
        bg = [UIColor grayColor];
    } else if ([self.curColorName containsString:@"brown"]) {
        bg = [UIColor brownColor];
    } else {
        bg = [UIColor purpleColor];
    }
    return bg;
}

@end
