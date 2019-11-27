//
//  BKPinCollectionViewModel.h
//  BKMVVMKit_Example
//
//  Created by lic on 2019/9/24.
//  Copyright © 2019 isingle. All rights reserved.
//

#import "BKVMCollectionViewModel.h"
#import "BKPinCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKPinCollectionViewModel : BKVMCollectionViewModel

- (void)requestList;
- (void)insertDemoCell;
- (void)removeDemoCell;

@end

NS_ASSUME_NONNULL_END
