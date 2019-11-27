//
//  BKVMTableViewModel.m
//  Pods
//
//  Created by lic on 2019/8/28.
//

#import "BKVMTableViewModel.h"
#import "UITableView+BKVMConfig.h"

static const NSInteger pageSize = 20;

@interface BKVMTableViewModel ()
@end

@implementation BKVMTableViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.perPage = pageSize;
        BKVM_WEAKSELF();
        self.dataCommand = [[BKCommand alloc] initWithCommandHandler:^(BKCommandEntry * _Nullable entry, BKCommandFinishedBlock  _Nonnull finishedHandler) {
            BKVM_STRONGSELF();
            [strongSelf bkvm_requestDataCommandWithEntry:entry atPage:strongSelf.page finishedHandler:finishedHandler];
        } cancelHandler:^{}];
        self.dataCommand.finishedHandler = ^(id _Nullable error, id _Nullable content, BKCommandStatus status) {
            BKVM_STRONGSELF();
            strongSelf.dataCommand.status = status;
            if (BKCommandStatusFailed == status) {
                strongSelf.dataCommand.response = [[BKCommandResponse alloc] initCommandResponse:nil error:error];
            } else if (BKCommandStatusSuccessed == status) {
                NSCAssert([content isKindOfClass:[NSArray class]] != 0, @"finishedHandler-content %@ must be NSArray", content);
                if ([content isKindOfClass:[NSArray class]]) {
                    NSArray *array = [NSArray arrayWithArray:content];
                    if (array.count > 0) {
                        if (strongSelf.sections.count > 0) {
                            strongSelf.sections = [strongSelf.sections arrayByAddingObjectsFromArray:array];
                        } else {
                            strongSelf.sections = array;
                        }
                    }
                }
                strongSelf.dataCommand.response = [[BKCommandResponse alloc] initCommandResponse:content error:nil];
            }
        };
    }
    return self;
}

- (void)setListParameter:(id)listParameter {
    _listParameter = listParameter;
    [self bkvm_requestListData:listParameter];
}

- (void)bkvm_requestListData:(id)params {
    BKCommandEntry *entry = [[BKCommandEntry alloc] initEntryWithParameter:params];
    [self.dataCommand execute:entry];
}

- (void)bkvm_requestMoreData {
    self.page ++;
    [self.dataCommand execute];
}

- (void)bkvm_refreshData {
    self.page = 1;
    [self.dataCommand execute];
}
//子类重写
- (void)bkvm_requestDataCommandWithEntry:(BKCommandEntry *)entry atPage:(NSUInteger)page finishedHandler:(BKCommandFinishedBlock)finishedHandler {
    
}

- (__kindof BKVMReusableViewModel *)cellViewModelWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sections.count && indexPath.row < self.sections[indexPath.section].rows) {
        BKVMReusableViewModel *viewModel = self.sections[indexPath.section].cellViewModels[indexPath.row];
        return viewModel;
    }
    return nil;
}

- (void)addTableViewModel:(NSArray<BKVMSectionViewModel *> *)sections {
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
    self.tableOperation = BKVMTableOperationInital;
}

- (void)addRowViewModels:(NSArray<BKVMReusableViewModel *> *)cellViewModels inSection:(NSUInteger)section {
    if (cellViewModels == nil || section > self.sections.count - 1) {
        return;
    }
    if (cellViewModels.count > 0) {
        BKVMSectionViewModel *sectionVM = [self.sections objectAtIndex:section];
        NSMutableArray *cells = [NSMutableArray arrayWithArray:sectionVM.cellViewModels];
        NSUInteger count = cells.count;
        [cells addObjectsFromArray:cellViewModels];
        sectionVM.cellViewModels = [cells copy];
        NSMutableArray *indexs = [NSMutableArray array];
        for (NSInteger i = count; i < cells.count; i ++) {
            [indexs addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        self.indexPaths = indexs;
        self.tableOperation = BKVMTableOperationAdd;
    }
}

- (void)addRowViewModel:(BKVMReusableViewModel *)cellViewModel indexPath:(NSIndexPath *)indexPath {
    if (cellViewModel) {
        if (indexPath.section < self.sections.count && indexPath.row < self.sections[indexPath.section].rows) {
            BKVMSectionViewModel *sectionVM = [self.sections objectAtIndex:indexPath.section];
            NSMutableArray *cells = [NSMutableArray arrayWithArray:sectionVM.cellViewModels];
            [cells insertObject:cellViewModel atIndex:indexPath.row];
            sectionVM.cellViewModels = [cells copy];
            self.indexPaths = @[indexPath];
            self.tableOperation = BKVMTableOperationAdd;
        }
    }
}

- (void)reloadRowWithViewModle:(BKVMReusableViewModel *)cellViewModel indexPath:(NSIndexPath *)indexPath {
    if (cellViewModel) {
        if (indexPath.section < self.sections.count && indexPath.row < self.sections[indexPath.section].rows) {
            NSMutableArray *cells = [NSMutableArray arrayWithArray:self.sections[indexPath.section].cellViewModels];
            [cells replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
            self.sections[indexPath.section].cellViewModels = [cells copy];
            self.indexPaths = @[indexPath];
            self.tableOperation = BKVMTableOperationReloadRow;
        }
    }
}

- (void)removeRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sections.count && indexPath.row < self.sections[indexPath.section].rows) {
        NSMutableArray *cellArr = [NSMutableArray arrayWithArray:self.sections[indexPath.section].cellViewModels];
        [cellArr removeObjectAtIndex:indexPath.row];
        self.sections[indexPath.section].cellViewModels = [cellArr copy];
        self.indexPaths = @[indexPath];
        self.tableOperation = BKVMTableOperationDelete;
    }
}

- (void)removeViewModel:(BKVMReusableViewModel *)cellViewModel {
    if (!cellViewModel) {
        return;
    }
    NSMutableArray *paths = [NSMutableArray array];
    for (NSInteger i = 0; i < self.sections.count; i ++) {
        NSMutableArray *cells = [NSMutableArray arrayWithArray:self.sections[i].cellViewModels];
        if ([cells containsObject:cellViewModel]) {
            [cells removeObject:cellViewModel];
            self.sections[i].cellViewModels = [cells copy];
            [paths addObject:[NSIndexPath indexPathForRow:[cells indexOfObject:cellViewModel] inSection:i]];
        }
    }
    self.indexPaths = paths;
    self.tableOperation = BKVMTableOperationDelete;
}

- (void)reloadMoreDataWithViewModels:(NSArray<BKVMReusableViewModel *> *)cellViewModels inSection:(NSUInteger)section {
    if (cellViewModels == nil || section > self.sections.count - 1) {
        return;
    }
    if (cellViewModels.count > 0) {
        BKVMSectionViewModel *sectionVM = [self.sections objectAtIndex:section];
        NSMutableArray *cells = [NSMutableArray arrayWithArray:sectionVM.cellViewModels];
        [cells addObjectsFromArray:cellViewModels];
        sectionVM.cellViewModels = [cells copy];
        self.tableOperation = BKVMTableOperationReloadMoreData;
    }
}

@end
