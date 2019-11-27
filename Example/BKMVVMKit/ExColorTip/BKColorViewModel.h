//
//  BKColorViewModel.h
//  Pods
//
//  Created by lic on 2019/9/6.
//

#import "BKVMBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKColorViewModel : BKVMBaseViewModel

@property (nonatomic, copy) NSString *curColorName;
@property (nonatomic, strong) UIColor *bgColor;

@end

NS_ASSUME_NONNULL_END
