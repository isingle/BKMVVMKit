//
//  UICollectionView+BKVMConfig.h
//  Pods
//
//  Created by lic on 2019/9/9.
//

#import <UIKit/UIKit.h>
#import "BKVMCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (BKVMConfig)

- (void)bkvm_registerCellWithViewModel:(__kindof BKVMCollectionViewModel *)viewModel;
- (void)bkvm_registerItemNibOrClass:(Class)viewClass identifier:identifier;
- (void)bkvm_registerHeaderFooterNibOrClass:(Class)viewClass ofKind:(NSString *)kind identifier:identifier;

@end

NS_ASSUME_NONNULL_END
