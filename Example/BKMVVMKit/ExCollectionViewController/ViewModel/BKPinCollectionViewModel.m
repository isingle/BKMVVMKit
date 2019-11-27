//
//  BKPinCollectionViewModel.m
//  BKMVVMKit_Example
//
//  Created by lic on 2019/9/24.
//  Copyright © 2019 isingle. All rights reserved.
//

#import "BKPinCollectionViewModel.h"
#import "BKColorModel.h"

@implementation BKPinCollectionViewModel

- (instancetype)init {
    if ([super init]) {
        __weak typeof(self) weakSelf = self;
        self.dataCommand = [[BKCommand alloc] initWithCommandHandler:^(BKCommandEntry * _Nullable entry, BKCommandFinishedBlock  _Nonnull finishedHandler) {
            //业务逻辑,e.g:网络请求
            __strong typeof(self) strongSelf = weakSelf;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf configDemoViewModels];
                finishedHandler(nil, strongSelf.sections, BKCommandStatusSuccessed);
            });
        } cancelHandler:^{
        }];
    }
    return self;
}

#pragma mark -- demo test
- (void)configDemoViewModels {
    NSMutableArray *viewModels = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"red", @"yellow", @"blue"];
    for (NSInteger i = 0; i < arr.count; i ++) {
        BKColorModel *model = [[BKColorModel alloc] initTitle:[arr objectAtIndex:i] isSelected:NO];
        BKPinCellViewModel *vm = [[BKPinCellViewModel alloc] initWithModel:model];
        [viewModels addObject:vm];
    }
    BKVMSectionViewModel *section = [[BKVMSectionViewModel alloc] initSectionViewModel:viewModels.copy];
    BKVMSectionViewModel *section1 = [[BKVMSectionViewModel alloc] initSectionViewModel:viewModels.copy];
    self.sections = @[section, section1];
}

#pragma mark - 数据操作
- (void)insertDemoCell {
    NSArray *arr = @[@"red"];
    BKColorModel *model = [[BKColorModel alloc] initTitle:[arr objectAtIndex:0] isSelected:NO];
    BKPinCellViewModel *vm = [[BKPinCellViewModel alloc] initWithModel:model];
//    BKVMSectionViewModel *section = [[BKVMSectionViewModel alloc] initSectionViewModel:@[vm]];
//    [self insertSections:@[section]];
    [self insertItems:@[vm]];
}

- (void)removeDemoCell {
    [self deleteItemWithIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]]];
}
#pragma mark - 执行命令
- (void)requestList {
    //执行命令, 可创建具体命令实体
    //    BKCommandEntry *entry = [[BKCommandEntry alloc] initEntryWithURL:@"http://" target:self];
    //    [self.dataCommand execute:entry];
    [self.dataCommand execute];
}

@end
