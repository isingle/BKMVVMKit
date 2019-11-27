//
//  UIViewController+BKVMConfig.h
//  Pods
//
//  Created by lic on 2019/9/5.
//

#import <UIKit/UIKit.h>
#import "BKVMBaseViewModel.h"
#import "BKVMViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BKVMConfig)

void bkvm_configureDelegate(UIView *view, id target);
void bkvm_binderWithViewModel(UIView *view, __kindof BKVMBaseViewModel *viewModel);

@end

NS_ASSUME_NONNULL_END
