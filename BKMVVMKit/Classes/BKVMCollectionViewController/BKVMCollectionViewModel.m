//
//  BKVMCollectionViewModel.m
//  Pods
//
//  Created by lic on 2019/8/29.
//

#import "BKVMCollectionViewModel.h"

NSString *const BKVM_CollectionHeaderIdentifier = @"BKVM_CollectionHeaderIdentifier";
NSString *const BKVM_CollectionFooterIdentifier = @"BKVM_CollectionFooterIdentifier";
NSString *const BKVM_CollectionItemIdentifier = @"BKVM_CollectionItemIdentifier";

@implementation BKVMCollectionViewModel

- (__kindof BKVMReusableViewModel *)itemViewModelWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sections.count && indexPath.row < self.sections[indexPath.section].rows) {
        BKVMReusableViewModel *viewModel = self.sections[indexPath.section].cellViewModels[indexPath.row];
        return viewModel;
    }
    return nil;
}

- (void)addCollectionViewModel:(NSArray<BKVMSectionViewModel *> *)sections {
    if (self.sections == nil) {
        self.sections = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.sections];
    [array addObjectsFromArray:sections];
    self.sections = [array copy];
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSInteger i = 0; i < self.sections.count; i ++) {
        [indexs addObject:[NSIndexPath indexPathForRow:i inSection:self.sections.count - 1]];
    }
    self.indexPaths = indexs;
    self.collectionOption = BKVMCollectionInsertSections;
}

- (void)reloadItemWithViewModle:(BKVMReusableViewModel *)itemViewModel indexPath:(NSIndexPath *)indexPath {
    if (itemViewModel) {
        if (indexPath.section < self.sections.count && indexPath.row < self.sections[indexPath.section].rows) {
            NSMutableArray *cells = [NSMutableArray arrayWithArray:self.sections[indexPath.section].cellViewModels];
            [cells replaceObjectAtIndex:indexPath.row withObject:itemViewModel];
            self.sections[indexPath.section].cellViewModels = [cells copy];
            self.indexPaths = @[indexPath];
            self.collectionOption = BKVMCollectioneReloadItems;
        }
    }
}

- (void)deleteItemWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 0) {
        return;
    }
    NSMutableArray *paths = [NSMutableArray array];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section < self.sections.count && obj.row < self.sections[obj.section].rows) {
            NSMutableArray *cellArr = [NSMutableArray arrayWithArray:self.sections[obj.section].cellViewModels];
            [cellArr removeObjectAtIndex:obj.row];
            self.sections[obj.section].cellViewModels = [cellArr copy];
            [paths addObject:obj];
        }
    }];
    self.indexPaths = [paths copy];
    self.collectionOption = BKVMCollectionDeleteItems;
}

- (void)insertItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels {
    return [self insertItems:itemViewModels section:0];
}

- (void)insertItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels section:(NSUInteger)section {
    if (itemViewModels == nil || section > self.sections.count - 1) {
        return;
    }
    NSMutableArray *paths = [NSMutableArray array];
    BKVMSectionViewModel *sectionViewModel = self.sections[section];
    NSMutableArray *cells = [NSMutableArray arrayWithArray:sectionViewModel.cellViewModels];
    if (cells == nil) {
        return;
    }
    [itemViewModels enumerateObjectsUsingBlock:^(BKVMReusableViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![cells containsObject:obj]) {
            [cells addObject:obj];
            [paths addObject:[NSIndexPath indexPathForItem:[cells indexOfObject:obj] inSection:section]];
        }
    }];
    sectionViewModel.cellViewModels = [cells copy];
    self.indexPaths = [paths copy];
    self.collectionOption = BKVMCollectionInsertItems;
}

- (void)deleteItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels {
    return [self deleteItems:itemViewModels section:0];
}

- (void)deleteItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels section:(NSUInteger)section {
    if (itemViewModels == nil || section > self.sections.count - 1) {
        return;
    }
    NSMutableArray *paths = [NSMutableArray array];
    BKVMSectionViewModel *sectionViewModel = self.sections[section];
    
    NSMutableArray *cells = [NSMutableArray arrayWithArray:sectionViewModel.cellViewModels];
    if (cells == nil) {
        return;
    }
    [itemViewModels enumerateObjectsUsingBlock:^(BKVMReusableViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cells containsObject:obj]) {
            [cells removeObject:obj];
            [paths addObject:[NSIndexPath indexPathForItem:[cells indexOfObject:obj] inSection:section]];
        }
    }];
    sectionViewModel.cellViewModels = [cells copy];
    self.indexPaths = [paths copy];
    self.collectionOption = BKVMCollectionDeleteItems;
}

- (void)insertSections:(NSArray<BKVMSectionViewModel *> *)sections {
    if (sections.count) {
        NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:self.sections];
        [sectionArr addObjectsFromArray:sections];
        self.sections = [sectionArr copy];
        NSIndexSet *result = [self.sections indexesOfObjectsPassingTest:^BOOL(BKVMSectionViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sections containsObject:obj]) {
                return YES;
            }
            return NO;
        }];
        self.indexSet = result;
        self.collectionOption = BKVMCollectionInsertSections;
    }
}

- (void)deleteSections:(NSArray<BKVMSectionViewModel *> *)sections {
    if (sections.count) {
        NSIndexSet *result = [self.sections indexesOfObjectsPassingTest:^BOOL(BKVMSectionViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sections containsObject:obj]) {
                NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:self.sections];
                [sectionArr removeObject:obj];
                self.sections = [sectionArr copy];
                return YES;
            }
            return NO;
        }];
        self.indexSet = result;
        self.collectionOption = BKVMCollectionDeleteSections;
    }
}

- (void)deleteSection:(NSUInteger)section {
    if (section < self.sections.count) {
        [self deleteSections:@[[self.sections objectAtIndex:section]]];
    }
}
@end
