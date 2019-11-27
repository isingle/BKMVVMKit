//
//  BKVMPinViewController.m
//  BKMVVMKit_Example
//
//  Created by lic on 2019/9/24.
//  Copyright © 2019 isingle. All rights reserved.
//

#import "BKPinViewController.h"
#import "BKColorView.h"
#import "BKPinCollectionViewModel.h"
#import "BKExHeader.h"
#import "BKPinCollectionViewCell.h"

#define kSpace 8.0f

@interface BKPinViewController ()<UICollectionViewDelegateFlowLayout, BKPinSelectedDelegate>
@property (nonatomic, strong) BKColorView *tipView;
@property (nonatomic, strong) BKPinCollectionViewModel *collectionViewModel;
@end

@implementation BKPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bkvm_binderWithViewModel:self.collectionViewModel];    
    [self.collectionViewModel requestList];
}

- (void)showExecuteStatus:(BKCommandStatus)status {
    switch (status) {
        case BKCommandStatusExecuting:
//            [[ProgressHUDHelper getInstance] showWithStatus:@"加载中..." onView:self.view];
            break;
        case BKCommandStatusSuccessed:
//            [[ProgressHUDHelper getInstance] dismissOnView:self.view];
            break;
        default:
//            [[ProgressHUDHelper getInstance] dismissOnView:self.view];
            break;
    }
}

- (void)cancelButton:(id)sender {
    [self.collectionViewModel removeDemoCell];
}

- (void)confirmButton:(id)sender {
    [self.collectionViewModel insertDemoCell];
}

#pragma mark - item delegate
- (void)changeTitle:(NSString *)title {
    self.tipView.viewModel.curColorName = title;
}

#pragma mark - BKVMCollectionDelegate
- (void)bkvm_registerItemWithIdentifier:(NSString *)identifier {
    [self.collectionView bkvm_registerItemNibOrClass:[BKPinCollectionViewCell class] identifier:identifier];
}

- (void)bkvm_registerSectionHeaderWithIdentifier:(NSString *)identifier {
    [self.collectionView bkvm_registerHeaderFooterNibOrClass:[BKPinHeaderView class] ofKind:UICollectionElementKindSectionHeader identifier:identifier];
}

- (void)bkvm_registerSectionFooterWithIdentifier:(NSString *)identifier {
    [self.collectionView bkvm_registerHeaderFooterNibOrClass:[BKPinHeaderView class] ofKind:UICollectionElementKindSectionFooter identifier:identifier];
}
//overwrite
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BKPinCellViewModel *vm = [self.collectionViewModel itemViewModelWithIndexPath:indexPath];
    self.tipView.viewModel.curColorName = vm.roleName;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BKVMReusableViewModel *viewModel = self.collectionViewModel.sections[indexPath.section].cellViewModels[indexPath.row];
    CGFloat hg = viewModel.viewHeight;
    CGFloat wd = MIN((CGRectGetWidth(collectionView.frame) - 3*kSpace) / 2, viewModel.viewWidth) ;
    return CGSizeMake(wd, hg);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(100, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(100, 30);
}

- (BKPinCollectionViewModel *)collectionViewModel {
    if (!_collectionViewModel) {
        _collectionViewModel = [[BKPinCollectionViewModel alloc] init];
    }
    return _collectionViewModel;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    UIBarButtonItem *backBtn = [self getBartButtonItemWithTitle:@"返回" action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItems = @[backBtn, [self getBartButtonItemWithTitle:@" 删除" action:@selector(cancelButton:)]];
    self.navigationItem.rightBarButtonItem = [self getBartButtonItemWithTitle:@"添加" action:@selector(confirmButton:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tipView = [[BKColorView alloc] initWithFrame:BKVM_RECT(0, BKVM_NAV_BAR_HEIGHT, CGRectGetWidth(self.view.frame), 60)];
    [self.view addSubview:self.tipView];
    self.collectionView.frame = CGRectMake(0, 60+BKVM_NAV_BAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-60-BKVM_NAV_BAR_HEIGHT);
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

@end

@implementation BKPinHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:BKVM_RECT(0, 0, 200, 30)];
        label.text = @" header / footer ...";
        [self addSubview:label];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
