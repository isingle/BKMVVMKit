//
//  BKVMViewProtocol.h
//  Pods
//
//  Created by lic on 2019/9/5.
//

#import <Foundation/Foundation.h>
#import "BKVMBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BKVMViewProtocol <NSObject>

/**
 bind viewModel --> view

 @param viewModel viewModel
 */
- (void)bkvm_binderWithViewModel:(__kindof BKVMBaseViewModel * _Nonnull)viewModel;
@optional
/**
 view 计算高度

 @param viewModel viewModel
 @return height
 */
+ (CGFloat)bkvm_viewHeightWithViewModel:(__kindof BKVMBaseViewModel * _Nonnull)viewModel;

/**
 view 计算宽度

 @param viewModel viewModel
 @return width
 */
+ (CGFloat)bkvm_viewWidthWithViewModel:(__kindof BKVMBaseViewModel * _Nonnull)viewModel;

@end

NS_ASSUME_NONNULL_END
