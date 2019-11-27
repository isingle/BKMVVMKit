//
//  BKVMCollectionController.m
//  Pods
//
//  Created by lic on 2019/9/9.
//

#import "BKVMCollectionController.h"
#import "KVOController.h"
#import "UIViewController+BKVMConfig.h"
#import "BKVMCollectionViewModel.h"
#import "BKVMMacro.h"

@interface BKVMCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) BKVMCollectionViewModel *viewModel;
@end

@implementation BKVMCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.delegate = self;
}

- (void)bkvm_binderWithViewModel:(__kindof BKVMBaseViewModel *)viewModel {
    self.viewModel = viewModel;
    [self observeCommand];
}

- (void)observeCommand {
    __weak typeof(self) weakSelf = self;
    //监听命令执行状态，处理交互
    [self.KVOController observe:self.viewModel keyPath:BKVM_COMMAND_STATUS options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        id value = change[NSKeyValueChangeNewKey];
        if (value) {
            __strong typeof(self) strongSelf = weakSelf;
            BKCommandStatus status = [value integerValue];
            [strongSelf showExecuteStatus:status];
        }
    }];
    //监听数据变化
    [self.KVOController observe:self.viewModel keyPath:BKVM_COMMAND_RESPONSE options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        id value = change[NSKeyValueChangeNewKey];
        if (value) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.collectionView bkvm_registerCellWithViewModel:strongSelf.viewModel];
            [strongSelf handleWithChanged:BKVMCollectionInital];
        }
    }];
    //监听列表操作
    [self.KVOController observe:self.viewModel keyPath:BKVM_COLLECTION_OPERATION options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        id value = change[NSKeyValueChangeNewKey];
        if (value) {
            __strong typeof(self) strongSelf = weakSelf;
            NSUInteger idx = [value integerValue];
            [strongSelf handleWithChanged:idx];
        }
    }];
}

- (void)handleWithChanged:(BKVMCollectionOption)option {
    switch (option) {
        case BKVMCollectionInital:
        case BKVMCollectionRefresh:
        {
            [self.collectionView reloadData];
            break;
        }
        case BKVMCollectionInsertItems:
        {
            [self.collectionView insertItemsAtIndexPaths:self.viewModel.indexPaths];
            break;
        }
        case BKVMCollectionDeleteItems:
        {
            [self.collectionView deleteItemsAtIndexPaths:self.viewModel.indexPaths];
            break;
        }
        case BKVMCollectionInsertSections:
        {
            [self.collectionView insertSections:self.viewModel.indexSet];
            break;
        }
        case BKVMCollectionDeleteSections:
        {
            [self.collectionView deleteSections:self.viewModel.indexSet];
            break;
        }
        case BKVMCollectioneReloadItems:
            [self.collectionView reloadItemsAtIndexPaths:self.viewModel.indexPaths];
            break;
        case BKVMCollectioneReloadSections:
            break;
            
        case BKVMCollectionMoveItem:
            break;
            
        case BKVMCollectionMoveSection:
            break;
            
        default:
            break;
    }
}
//子类需要重写
- (void)showExecuteStatus:(BKCommandStatus)status {
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.viewModel) {
        return self.viewModel.sections ? self.viewModel.sections.count : 1;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.sections[section].rows;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BKVMReusableViewModel *viewModel = self.viewModel.sections[indexPath.section].cellViewModels[indexPath.row];
    NSString *identifier = BKVM_CollectionItemIdentifier;
    if (viewModel.identifier) {
        identifier = viewModel.identifier;
    }
    UICollectionViewCell *cell;
    if ([_delegate respondsToSelector:@selector(bkvm_registerItemWithIdentifier:)]) {
        [_delegate bkvm_registerItemWithIdentifier:identifier];
    }
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath] ;
    bkvm_configureDelegate(cell, self);
    bkvm_binderWithViewModel(cell, viewModel);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BKVMReusableViewModel *headerViewModel = self.viewModel.sections[indexPath.section].headerViewModel;
        NSString *identifier = BKVM_CollectionHeaderIdentifier;
        if (headerViewModel.identifier) {
            identifier = headerViewModel.identifier;
        }
        UICollectionReusableView *view;
        if ([_delegate respondsToSelector:@selector(bkvm_registerSectionHeaderWithIdentifier:)]) {
            [_delegate bkvm_registerSectionHeaderWithIdentifier:identifier];
        }
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if (view) {
            bkvm_configureDelegate(view, self);
            bkvm_binderWithViewModel(view, headerViewModel);
        }
        return view;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        BKVMReusableViewModel *footerViewModel = self.viewModel.sections[indexPath.section].footerViewModel;
        NSString *identifier = BKVM_CollectionFooterIdentifier;
        if (footerViewModel.identifier) {
            identifier = footerViewModel.identifier;
        }
        UICollectionReusableView *view;
        if ([_delegate respondsToSelector:@selector(bkvm_registerSectionFooterWithIdentifier:)]) {
            [_delegate bkvm_registerSectionFooterWithIdentifier:identifier];
        }
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if (view) {
            bkvm_configureDelegate(view, self);
            bkvm_binderWithViewModel(view, footerViewModel);
        }
        return view;
    }
    return nil;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}
@end
