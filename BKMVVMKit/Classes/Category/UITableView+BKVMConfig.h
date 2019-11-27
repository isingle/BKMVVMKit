//
//  UITableView+BKVMConfig.h
//  Pods
//
//  Created by lic on 2019/8/27.
//

#import <UIKit/UIKit.h>
#import "BKVMTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (BKVMConfig)

- (void)bkvm_registerCellWithViewModel:(__kindof BKVMTableViewModel *)viewModel;
- (void)bkvm_registerHeaderFooterNibOrClass:(Class)viewClass identifier:(NSString *)identifier;
- (void)bkvm_registerCellNibOrClass:(Class)viewClass identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
