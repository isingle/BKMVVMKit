//
//  BKVMTableViewModel.h
//  Pods
//
//  Created by lic on 2019/8/28.
//

#import "BKVMBaseViewModel.h"
#import "BKVMSectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BKVMTableOperationDefault = 0,
    BKVMTableOperationInital,
    BKVMTableOperationAdd,
    BKVMTableOperationDelete,
    BKVMTableOperationRefresh,
    BKVMTableOperationReloadRow,
    BKVMTableOperationReloadSection,
    BKVMTableOperationReloadMoreData,
} BKVMTableOperation;

@interface BKVMTableViewModel : BKVMBaseViewModel

@property (nonatomic, assign) BKVMTableOperation tableOperation;
@property (nonatomic, strong, nullable) NSArray<BKVMSectionViewModel *> *sections;
@property (nonatomic, strong) NSArray<NSIndexPath *> *indexPaths;
@property (nonatomic, strong, nullable) id listParameter;
/**
 *  当前页
 */
@property (assign, nonatomic) NSUInteger page;

/**
 *  每页cell数量
 */
@property (assign, nonatomic) NSUInteger perPage;

/**
 *  cell总数量
 */
@property (assign, nonatomic) NSUInteger totalCount;

/// 总页数
@property (assign, nonatomic) NSUInteger totalPage;

/**
 * YES:没有更多数据 NO:更多数据
 */
@property (nonatomic, assign) BOOL hasNoMoreData;

+ (instancetype)new NS_UNAVAILABLE;

//子类重写，获取数据
- (void)bkvm_requestDataCommandWithEntry:(BKCommandEntry *)entry atPage:(NSUInteger)page finishedHandler:(BKCommandFinishedBlock)finishedHandler;
- (void)bkvm_requestListData:(id)params;
- (void)bkvm_requestMoreData;
- (void)bkvm_refreshData;

//get viewModel with indexPath
- (__kindof BKVMReusableViewModel *)cellViewModelWithIndexPath:(NSIndexPath *)indexPath;

//添加多个分区
- (void)addTableViewModel:(NSArray<BKVMSectionViewModel *> *)sections;
//添加多行
- (void)addRowViewModels:(NSArray<BKVMReusableViewModel *> *)cellViewModels inSection:(NSUInteger)section;
//插入单行
- (void)addRowViewModel:(BKVMReusableViewModel *)cellViewModel indexPath:(NSIndexPath *)indexPath;
//刷新单行
- (void)reloadRowWithViewModle:(BKVMReusableViewModel *)cellViewModel indexPath:(NSIndexPath *)indexPath;
//移除单行
- (void)removeRowWithIndexPath:(NSIndexPath *)indexPath;
//移除指定 viewModel 对应行
- (void)removeViewModel:(BKVMReusableViewModel *)cellViewModel;
//加载更多
- (void)reloadMoreDataWithViewModels:(NSArray<BKVMReusableViewModel *> *)cellViewModels inSection:(NSUInteger)section;
@end

NS_ASSUME_NONNULL_END
