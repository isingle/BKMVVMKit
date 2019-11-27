//
//  UIViewController+BKVMConfig.m
//  Pods
//
//  Created by lic on 2019/9/5.
//

#import "UIViewController+BKVMConfig.h"
#import "NSObject+BKVMDelegator.h"

@implementation UIViewController (BKVMConfig)

void bkvm_configureDelegate(UIView *view, id target) {
    if (view) {
        view.rawDelegate = target;
    }
}

void bkvm_binderWithViewModel(UIView<BKVMViewProtocol> *view, __kindof BKVMBaseViewModel *viewModel) {
    if ([view respondsToSelector:@selector(bkvm_binderWithViewModel:)]) {
        [view bkvm_binderWithViewModel:viewModel];
    }
}

@end
