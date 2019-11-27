//
//  UITableViewCell+BKVMConfig.m
//  Pods
//
//  Created by lic on 2019/8/27.
//

#import "UITableViewCell+BKVMConfig.h"

@implementation UITableViewCell (BKVMConfig)

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

@end
