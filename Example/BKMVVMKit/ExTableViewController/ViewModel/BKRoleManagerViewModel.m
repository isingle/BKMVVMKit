//
//  BKRoleManagerViewModel.m
//  Pods
//
//  Created by lic on 2019/8/28.
//

#import "BKRoleManagerViewModel.h"
#import "UITableView+BKVMConfig.h"
#import "UITableViewCell+BKVMConfig.h"
#import "BKRoleCellViewModel.h"
#import "BKColorModel.h"

@interface BKRoleManagerViewModel ()
@property (nonatomic, strong) BKCommandEntry *entry;
@end

@implementation BKRoleManagerViewModel
//获取数据
- (void)bkvm_requestDataCommandWithEntry:(BKCommandEntry *)entry atPage:(NSUInteger)page finishedHandler:(BKCommandFinishedBlock)finishedHandler {
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = weakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *sections = [strongSelf configDemoViewModels];
        finishedHandler(nil, sections, BKCommandStatusSuccessed);
    });
}

#pragma mark -- demo test
- (NSArray *)configDemoViewModels {
    NSMutableArray *viewModels = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"red", @"yellow", @"blue", @"gray", @"brown"];
    for (NSInteger i = 0; i < arr.count; i ++) {
        BKColorModel *model = [[BKColorModel alloc] initTitle:[arr objectAtIndex:i] isSelected:NO];
        BKRoleCellViewModel *vm = [[BKRoleCellViewModel alloc] initWithModel:model];
        [viewModels addObject:vm];
    }
    BKVMSectionViewModel *section = [[BKVMSectionViewModel alloc] initSectionViewModel:viewModels.copy];
    //
    NSArray *arr1 = @[@"gray", @"brown"];
    [viewModels removeAllObjects];
    for (NSInteger i = 0; i < arr1.count; i ++) {
        BKColorModel *model = [[BKColorModel alloc] initTitle:[arr objectAtIndex:i] isSelected:NO];
        BKRoleCellViewModel *vm = [[BKRoleCellViewModel alloc] initWithModel:model];
        [viewModels addObject:vm];
    }
    BKVMSectionViewModel *section1 = [[BKVMSectionViewModel alloc] initSectionViewModel:viewModels.copy];
    return @[section, section1];
}

#pragma mark - 数据操作
- (void)insertDemoCell {
    NSArray *arr = @[@"red"];
    BKColorModel *model = [[BKColorModel alloc] initTitle:[arr objectAtIndex:0] isSelected:NO];
    BKRoleCellViewModel *vm = [[BKRoleCellViewModel alloc] initWithModel:model];
    [self addRowViewModels:@[vm] inSection:0];
}

- (void)removeDemoCell {
    [self removeRowWithIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
}

#pragma mark - 执行命令
- (void)requestList {
    //执行命令, 可创建具体命令实体
    self.entry = [[BKCommandEntry alloc] initEntryWithURL:@"http://demo.com" target:self];
    [self.dataCommand execute:self.entry];
}

@end
