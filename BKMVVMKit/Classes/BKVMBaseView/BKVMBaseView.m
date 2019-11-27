//
//  BKVMBaseView.m
//  Pods
//
//  Created by lic on 2019/9/6.
//

#import "BKVMBaseView.h"

@interface BKVMBaseView ()
@end

@implementation BKVMBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
    }
    return self;
}

#pragma mark - protocol 子类实现
- (void)bkvm_binderWithViewModel:(__kindof BKVMBaseViewModel *)viewModel {
}


@end
