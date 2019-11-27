//
//  BKVMCollectionViewModel.h
//  Pods
//
//  Created by lic on 2019/8/29.
//

#import "BKVMBaseViewModel.h"
#import "BKVMSectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const BKVM_CollectionHeaderIdentifier;
UIKIT_EXTERN NSString *const BKVM_CollectionFooterIdentifier;
UIKIT_EXTERN NSString *const BKVM_CollectionItemIdentifier;

typedef enum : NSUInteger {
    BKVMCollectionDefault = 0,
    BKVMCollectionInital,
    BKVMCollectionRefresh,
    BKVMCollectionInsertItems,
    BKVMCollectionInsertSections,
    BKVMCollectionDeleteItems,
    BKVMCollectionDeleteSections,
    BKVMCollectionMoveItem,
    BKVMCollectionMoveSection,
    BKVMCollectioneReloadItems,
    BKVMCollectioneReloadSections,
} BKVMCollectionOption;

@interface BKVMCollectionViewModel : BKVMBaseViewModel

@property (nonatomic, strong) NSArray<BKVMSectionViewModel *> *sections;
@property (nonatomic, assign) BKVMCollectionOption collectionOption;
@property (nonatomic, strong) NSArray<NSIndexPath *> *indexPaths;
@property (nonatomic, strong) NSIndexSet *indexSet;

//- (instancetype)initWithCollectionView:(UICollectionView *)collection;
//获取 viewModel
- (__kindof BKVMReusableViewModel *)itemViewModelWithIndexPath:(NSIndexPath *)indexPath;
//刷新 item
- (void)reloadItemWithViewModle:(BKVMReusableViewModel *)itemViewModel indexPath:(NSIndexPath *)indexPath;
//插入 section
- (void)insertSections:(NSArray<BKVMSectionViewModel *> *)sections;

//插入 items
- (void)insertItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels;
- (void)insertItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels section:(NSUInteger)section;

//删除 items
- (void)deleteItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels;
- (void)deleteItems:(NSArray<BKVMReusableViewModel *> *)itemViewModels section:(NSUInteger)section;
- (void)deleteItemWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deleteSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
