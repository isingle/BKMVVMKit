//
//  UICollectionView+BKVMConfig.m
//  Pods
//
//  Created by lic on 2019/9/9.
//

#import "UICollectionView+BKVMConfig.h"

@implementation UICollectionView (BKVMConfig)

- (void)bkvm_registerCellWithViewModel:(__kindof BKVMCollectionViewModel *)viewModel {
    for (BKVMSectionViewModel *sectionViewModel in viewModel.sections) {
        if (sectionViewModel.headerViewModel) {
            [self registerHeaderFooterNibOrClass:sectionViewModel.headerViewModel ofKind:UICollectionElementKindSectionHeader];
        }
        if (sectionViewModel.footerViewModel) {
            [self registerHeaderFooterNibOrClass:sectionViewModel.footerViewModel ofKind:UICollectionElementKindSectionFooter];
        }
        for (BKVMReusableViewModel *cellModel in sectionViewModel.cellViewModels) {
            [self registerNibOrClass:cellModel];
        }
    }
}

- (void)registerNibOrClass:(BKVMReusableViewModel *)model {
    [self bkvm_registerItemNibOrClass:model.viewClass identifier:model.identifier];
}

- (void)registerHeaderFooterNibOrClass:(BKVMReusableViewModel *)model ofKind:(NSString *)kind {
    [self bkvm_registerHeaderFooterNibOrClass:model.viewClass ofKind:kind identifier:model.identifier];
}

- (void)bkvm_registerHeaderFooterNibOrClass:(Class)viewClass ofKind:(NSString *)kind identifier:identifier {
    if (viewClass && [[[NSBundle mainBundle] pathForResource:NSStringFromClass(viewClass) ofType:@"nib"] length]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(viewClass) bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
    } else if (identifier && viewClass) {
        [self registerClass:viewClass forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
    }
}

- (void)bkvm_registerItemNibOrClass:(Class)viewClass identifier:identifier {
    if (viewClass && [[[NSBundle mainBundle] pathForResource:NSStringFromClass(viewClass) ofType:@"nib"] length]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(viewClass) bundle:nil] forCellWithReuseIdentifier:identifier];
    } else if (identifier) {
        [self registerClass:viewClass forCellWithReuseIdentifier:identifier];
    }
}

@end
