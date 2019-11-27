//
//  BKVMSectionViewModel.h
//  Pods
//
//  Created by lic on 2019/9/4.
//

#import "BKVMBaseViewModel.h"
#import "BKVMReusableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKVMSectionViewModel : BKVMBaseViewModel

@property (nonatomic, strong) NSArray<BKVMReusableViewModel *> *cellViewModels;
@property (nonatomic, strong, readonly) BKVMReusableViewModel *headerViewModel;
@property (nonatomic, strong, readonly) BKVMReusableViewModel *footerViewModel;
@property (nonatomic, assign, readonly) NSUInteger rows;

- (instancetype)init NS_UNAVAILABLE;
//默认没有 header & footer
- (instancetype)initSectionViewModel:(__kindof NSArray<BKVMReusableViewModel *> *)cellViewModels;
// 初始化 header / footer viewModel
- (instancetype)initSectionViewModel:(NSArray<BKVMReusableViewModel *> *)cellViewModels headerViewModel:(BKVMReusableViewModel * _Nullable)headerViewModel footerViewModel:(BKVMReusableViewModel * _Nullable)footerViewModel NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
