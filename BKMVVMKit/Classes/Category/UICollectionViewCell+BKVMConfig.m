//
//  UICollectionViewCell+BKVMConfig.m
//  Pods
//
//  Created by lic on 2019/8/29.
//

#import "UICollectionViewCell+BKVMConfig.h"

@implementation UICollectionViewCell (BKVMConfig)

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}
@end
