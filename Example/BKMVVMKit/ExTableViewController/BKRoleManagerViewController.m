//
//  BKRoleManagerViewController.m
//  Pods
//
//  Created by lic on 2019/8/27.
//

#import "BKRoleManagerViewController.h"
#import "BKRoleManagerViewModel.h"
#import "KVOController.h"
#import "BKRoleCellViewModel.h"
#import "UITableViewCell+BKVMConfig.h"
#import "BKColorView.h"
#import "BKExHeader.h"

@interface BKRoleManagerViewController ()
@property (nonatomic, strong) BKRoleManagerViewModel *viewModel;
@property (nonatomic, strong) BKColorView *tipView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation BKRoleManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bkvm_configRefreshEnable:YES];
    [self bkvm_binderWithViewModel:self.viewModel];
    [self.viewModel setListParameter:nil];
}
#pragma mark - 重写、加载提示
- (void)showExecuteResultWithStatus:(BKCommandStatus)status {
    switch (status) {
        case BKCommandStatusExecuting:
//            [[ProgressHUDHelper getInstance] showWithStatus:@"加载中..." onView:self.view];
            [self.activityView startAnimating];
            break;
        case BKCommandStatusSuccessed:
//            [[ProgressHUDHelper getInstance] dismissOnView:self.view];
            [self.activityView stopAnimating];
            break;
        default:
//            [[ProgressHUDHelper getInstance] dismissOnView:self.view];
            [self.activityView stopAnimating];
            break;
    }
}

- (void)deleteButton:(id)sender {
    [self.viewModel removeDemoCell];
}

- (void)addButton:(id)sender {
    [self.viewModel insertDemoCell];
}

#pragma mark - RoleSelectedDelegate
- (void)changeTitle:(NSString *)title {
    self.tipView.viewModel.curColorName = title;
}

#pragma mark - BKVMTableSectionDelegate
- (UIView *)viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    label.backgroundColor = [UIColor brownColor];
    label.text = @" section header ！！！";
    return label;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    label.backgroundColor = [UIColor orangeColor];
    label.text = @" footer header ！！！";
    return label;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    return 30;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BKRoleCellViewModel *vm = [self.viewModel cellViewModelWithIndexPath:indexPath];
    self.tipView.viewModel.curColorName = vm.roleName;
}

- (BKRoleManagerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BKRoleManagerViewModel alloc] init];
    }
    return _viewModel;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    UIBarButtonItem *backBtn = [self getBartButtonItemWithTitle:@"返回" action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItems = @[backBtn, [self getBartButtonItemWithTitle:@" 删除" action:@selector(deleteButton:)]];
    self.navigationItem.rightBarButtonItem = [self getBartButtonItemWithTitle:@"添加" action:@selector(addButton:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tipView = [[BKColorView alloc] initWithFrame:BKVM_RECT(0, BKVM_NAV_BAR_HEIGHT, CGRectGetWidth(self.view.frame), 60)];
    [self.view addSubview:self.tipView];
    self.listTableView.frame = CGRectMake(0, 60+BKVM_NAV_BAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-60-BKVM_NAV_BAR_HEIGHT);
}

- (UIBarButtonItem *)getBartButtonItemWithTitle:(NSString *)title action:(SEL)action {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:action];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor blackColor],
                                 NSFontAttributeName:BKVM_FONT(16)
                                 };
    [barButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    return barButtonItem;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _activityView.center = self.view.center;
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityView.hidesWhenStopped = YES;
        _activityView.color = [UIColor blackColor];
        [self.view addSubview:_activityView];
    }
    return _activityView;
}

@end
