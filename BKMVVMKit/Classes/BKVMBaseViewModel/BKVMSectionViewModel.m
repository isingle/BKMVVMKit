//
//  BKVMSectionViewModel.m
//  Pods
//
//  Created by lic on 2019/9/4.
//

#import "BKVMSectionViewModel.h"

@interface BKVMSectionViewModel ()
@property (nonatomic, strong) BKVMReusableViewModel *headerViewModel;
@property (nonatomic, strong) BKVMReusableViewModel *footerViewModel;
@end

@implementation BKVMSectionViewModel

- (instancetype)initSectionViewModel:(__kindof NSArray<BKVMReusableViewModel *> *)cellViewModels {
    return [self initSectionViewModel:cellViewModels headerViewModel:nil footerViewModel:nil];
}

- (instancetype)initSectionViewModel:(NSArray<BKVMReusableViewModel *> *)cellViewModels headerViewModel:(BKVMReusableViewModel *)headerViewModel footerViewModel:(BKVMReusableViewModel *)footerViewModel {
    if ([super init]) {
        _cellViewModels = cellViewModels;
        _headerViewModel = headerViewModel;
        _footerViewModel = footerViewModel;
    }
    return self;
}

- (NSUInteger)rows {
    return self.cellViewModels.count;
}

@end
