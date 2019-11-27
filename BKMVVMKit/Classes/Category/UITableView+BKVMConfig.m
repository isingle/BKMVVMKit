//
//  UITableView+BKVMConfig.m
//  Pods
//
//  Created by lic on 2019/8/27.
//

#import "UITableView+BKVMConfig.h"

@implementation UITableView (BKVMConfig)

- (void)bkvm_registerCellWithViewModel:(__kindof BKVMTableViewModel *)viewModel {
    for (BKVMSectionViewModel *sectionViewModel in viewModel.sections) {
        if (sectionViewModel.headerViewModel) {
            [self registerHeaderFooterNibOrClass:sectionViewModel.headerViewModel];
        }
        if (sectionViewModel.footerViewModel) {
            [self registerHeaderFooterNibOrClass:sectionViewModel.footerViewModel];
        }
        for (BKVMReusableViewModel *cellModel in sectionViewModel.cellViewModels) {
            [self registerNibOrClass:cellModel];
        }
    }
}

- (void)registerNibOrClass:(BKVMReusableViewModel *)model {
    [self bkvm_registerCellNibOrClass:model.viewClass identifier:model.identifier];
}

- (void)registerHeaderFooterNibOrClass:(BKVMReusableViewModel *)model {
    [self bkvm_registerHeaderFooterNibOrClass:model.viewClass identifier:model.identifier];
}

- (void)bkvm_registerCellNibOrClass:(Class)viewClass identifier:(NSString *)identifier {
    if (viewClass && [[[NSBundle mainBundle] pathForResource:NSStringFromClass(viewClass) ofType:@"nib"] length]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(viewClass) bundle:nil] forCellReuseIdentifier:identifier];
    } else if (identifier) {
        [self registerClass:viewClass forCellReuseIdentifier:identifier];
    }
}

- (void)bkvm_registerHeaderFooterNibOrClass:(Class)viewClass identifier:(NSString *)identifier {
    if (viewClass && [[[NSBundle mainBundle] pathForResource:NSStringFromClass(viewClass) ofType:@"nib"] length]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(viewClass) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
    } else if (identifier) {
        [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:identifier];
    }
}

@end
