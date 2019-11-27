//
//  BKVMTableController.m
//  Pods
//
//  Created by lic on 2019/8/30.
//

#import "BKVMTableController.h"
#import "BKVMTableViewModel.h"
#import "KVOController.h"
#import "UIViewController+BKVMConfig.h"
#import "UITableView+BKVMConfig.h"
#import "UITableViewCell+BKVMConfig.h"
#import "BKVMMacro.h"
#import "MJRefresh.h"

@interface BKVMTableController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BKVMTableViewModel *viewModel;
@property (nonatomic, assign) UITableViewStyle style;
@end

@implementation BKVMTableController

- (instancetype)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listTableView];
    [self bkvm_configRefreshEnable:YES];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.delegate = self;
}

- (void)bkvm_binderWithViewModel:(BKVMTableViewModel *)viewModel {
    self.viewModel = viewModel;
    [self observeCommand];
}

- (void)observeCommand {
    BKVM_WEAKSELF();
    //监听命令执行状态，处理交互
    [self.KVOController observe:self.viewModel keyPath:BKVM_COMMAND_STATUS options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        id value = change[NSKeyValueChangeNewKey];
        if (value && ![value isEqual:[NSNull null]]) {
            BKVM_STRONGSELF();
            BKCommandStatus status = [value integerValue];
            [strongSelf showExecuteResultWithStatus:status];
        }
    }];
    //监听请求到的数据变化
    [self.KVOController observe:self.viewModel keyPath:BKVM_COMMAND_RESPONSE options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        BKVM_STRONGSELF();
        [strongSelf tableViewEndRefreshing];
        id value = change[NSKeyValueChangeNewKey];
        if (value && ![value isEqual:[NSNull null]]) {
            if (strongSelf.viewModel.dataCommand.response.content) {
                [strongSelf.listTableView bkvm_registerCellWithViewModel:strongSelf.viewModel];
                [strongSelf handleWithChanged:BKVMTableOperationInital];
            }
        }
        [strongSelf showExecuteTip:strongSelf.viewModel];
    }];
    //监听列表操作
    [self.KVOController observe:self.viewModel keyPath:BKVM_TABLE_OPERATION options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        BKVM_STRONGSELF();
        [strongSelf tableViewEndRefreshing];
        id value = change[NSKeyValueChangeNewKey];
        if (value && ![value isEqual:[NSNull null]]) {
            NSUInteger idx = [value integerValue];
            [strongSelf handleWithChanged:idx];
        }
    }];
}

- (void)showExecuteTip:(BKVMTableViewModel *)viewModel {
    if (viewModel.sections.count == 0) {
        if (BKCommandStatusFailed == viewModel.dataCommand.status) {
//            [self showNoDataViewInView:self.listTableView withErrorType:ErrorTypeLoadFail withClickBlock:^{
//                [self dismissNoDataView];
//                [self.viewModel bkvm_refreshData];
//            }];
        } else if (BKCommandStatusSuccessed == viewModel.dataCommand.status) {
//            [self showNoDataViewInView:self.listTableView withErrorType:ErrorTypeNoData withClickBlock:nil];
        }
        [self showPullUpOrDownRefreshEnable:NO];
    } else {
        if (BKCommandStatusFailed == viewModel.dataCommand.status) {
            [self showExecuteResultWithStatus:BKCommandStatusFailed];
        }
        [self showPullUpOrDownRefreshEnable:YES];
    }
}

- (void)handleWithChanged:(BKVMTableOperation)operation {
    switch (operation) {
        case BKVMTableOperationInital:
        case BKVMTableOperationRefresh:
        {
            [self.listTableView reloadData];
            break;
        }
        case BKVMTableOperationReloadMoreData:
        {
            [self.listTableView reloadData];
            break;
        }
        case BKVMTableOperationAdd:
            [self.listTableView insertRowsAtIndexPaths:self.viewModel.indexPaths withRowAnimation:UITableViewRowAnimationFade];
            break;
        case BKVMTableOperationDelete:
            [self.listTableView deleteRowsAtIndexPaths:self.viewModel.indexPaths withRowAnimation:UITableViewRowAnimationFade];
            break;
        case BKVMTableOperationReloadRow:
            [self.listTableView reloadRowsAtIndexPaths:self.viewModel.indexPaths withRowAnimation:UITableViewRowAnimationFade];
            break;
        case BKVMTableOperationReloadSection:
            break;
        default:
            break;
    }
}
//子类可以重写
- (void)showExecuteResultWithStatus:(BKCommandStatus)status {
    switch (status) {
        case BKCommandStatusExecuting:
//            [[ProgressHUDHelper getInstance] showWithStatus:BKVM_STRING_LOADING onView:self.view];
            break;
        case BKCommandStatusSuccessed:
//            [[ProgressHUDHelper getInstance] dismissOnView:self.view];
            break;
        case BKCommandStatusFailed:
//            [[ProgressHUDHelper getInstance] showInfoWithStatus:BKVM_STRING_FETCH_FAIL onView:self.view];
            break;
        case BKCommandStatusCancelled:
//            [[ProgressHUDHelper getInstance] showInfoWithStatus:BKVM_STRING_CANCEL_LOADING onView:self.view];
            break;
        default:
//            [[ProgressHUDHelper getInstance] dismissOnView:self.view];
            break;
    }
}

#pragma mark - 下拉，上拉刷新
- (void)bkvm_configRefreshEnable:(BOOL)enable {
    [self bkvm_setPullUpRefreshEnable:enable];
    [self bkvm_setPullDownRefreshEnable:enable];
}

- (void)showPullUpOrDownRefreshEnable:(BOOL)enable {
    if (enable) {
        self.listTableView.mj_header.hidden = NO;
        self.listTableView.mj_footer.hidden = NO;
    } else {
        self.listTableView.mj_header.hidden = YES;
        self.listTableView.mj_footer.hidden = YES;
    }
}
// 上拉加载更多
- (void)bkvm_setPullUpRefreshEnable:(BOOL)enable {
    BKVM_WEAKSELF();
    if (enable) {
        self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            BKVM_STRONGSELF();
                        if (strongSelf.viewModel.totalPage > 0 && strongSelf.viewModel.page+1 > strongSelf.viewModel.totalPage) {
                            strongSelf.listTableView.mj_footer.hidden = YES;
                            return;
                        }
            //            [self dismissNoDataView];
                        [strongSelf.viewModel bkvm_requestMoreData];
        }];
    }
}

//下拉刷新
- (void)bkvm_setPullDownRefreshEnable:(BOOL)enable {
    BKVM_WEAKSELF();
    if (enable) {
        self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            BKVM_STRONGSELF();
                        if (strongSelf.viewModel.sections) {
                            strongSelf.viewModel.sections = nil;
                        }
            //            [self dismissNoDataView];
                        [strongSelf.viewModel bkvm_refreshData];
        }];
    }
}

- (void)tableViewEndRefreshing {
    if (self.listTableView.mj_header.isRefreshing) {
        [self.listTableView.mj_header endRefreshing];
    }
    if (self.listTableView.mj_footer.isRefreshing) {
        [self.listTableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel) {
        return self.viewModel.sections ? self.viewModel.sections.count : 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = self.viewModel.sections[section].rows;
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.viewModel.sections[indexPath.section].rows - 1) {
        return [UITableViewCell new];
    }
    BKVMReusableViewModel *viewModel = self.viewModel.sections[indexPath.section].cellViewModels[indexPath.row];
    UITableViewCell<BKVMViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:viewModel.identifier];
    if (cell == nil) {
        Class cellClass = viewModel.viewClass;
        if (!cellClass) {
            cellClass = [UITableViewCell class];
        }
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewModel.identifier];
    }
    bkvm_configureDelegate(cell, self);
    bkvm_binderWithViewModel(cell, viewModel);
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKVMReusableViewModel *viewModel = self.viewModel.sections[indexPath.section].cellViewModels[indexPath.row];
    CGFloat height = viewModel.viewHeight;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BKVMReusableViewModel *headerViewModel = self.viewModel.sections[section].headerViewModel;
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewModel.identifier];
    if ([_delegate respondsToSelector:@selector(viewForHeaderInSection:)]) {
        view =  [_delegate viewForHeaderInSection:section];
    }
    if (view) {
        bkvm_configureDelegate(view, self);
        bkvm_binderWithViewModel(view, headerViewModel);
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BKVMReusableViewModel *footerViewModel = self.viewModel.sections[section].footerViewModel;
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewModel.identifier];
    if ([_delegate respondsToSelector:@selector(viewForFooterInSection:)]) {
        view =  [_delegate viewForFooterInSection:section];
    }
    if (view) {
        bkvm_configureDelegate(view, self);
        bkvm_binderWithViewModel(view, footerViewModel);
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    BKVMReusableViewModel *headerViewModel = self.viewModel.sections[section].headerViewModel;
    CGFloat height = headerViewModel ? headerViewModel.viewHeight : UITableViewAutomaticDimension;
    if (UITableViewAutomaticDimension == height) {
        if ([_delegate respondsToSelector:@selector(heightForHeaderInSection:)]) {
            height = [_delegate heightForHeaderInSection:section];
        } else {
            height = CGFLOAT_MIN;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BKVMReusableViewModel *footerViewModel = self.viewModel.sections[section].footerViewModel;
    CGFloat height = footerViewModel ? footerViewModel.viewHeight : UITableViewAutomaticDimension;
    if (UITableViewAutomaticDimension == height) {
        if ([_delegate respondsToSelector:@selector(heightForFooterInSection:)]) {
            height = [_delegate heightForFooterInSection:section];
        } else {
            height = CGFLOAT_MIN;
        }
    }
    return height;
}

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
        _listTableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _listTableView;
}

@end
