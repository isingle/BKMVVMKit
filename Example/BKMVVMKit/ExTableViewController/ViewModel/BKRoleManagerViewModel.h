//
//  BKRoleManagerViewModel.h
//  Pods
//
//  Created by lic on 2019/8/28.
//

#import <UIKit/UIKit.h>
#import "BKVMTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKRoleManagerViewModel : BKVMTableViewModel

- (void)requestList;
- (void)insertDemoCell;
- (void)removeDemoCell;

@end

NS_ASSUME_NONNULL_END
