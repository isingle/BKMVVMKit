//
//  BKVMTableController.h
//  Pods
//
//  Created by lic on 2019/8/30.
//

#import <UIKit/UIKit.h>
#import "BKVMViewProtocol.h"
#import "UITableView+BKVMConfig.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BKVMTableSectionDelegate <NSObject>

@optional
//set header view height
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
//custom view for header
- (nullable UIView *)viewForHeaderInSection:(NSInteger)section;
//set footer view height
- (CGFloat)heightForFooterInSection:(NSInteger)section;
//custom view for footer
- (nullable UIView *)viewForFooterInSection:(NSInteger)section;

@end

@interface BKVMTableController : UIViewController <BKVMViewProtocol, BKVMTableSectionDelegate>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, weak) id<BKVMTableSectionDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewStyle)style;
//执行状态, 子类重载
- (void)showExecuteResultWithStatus:(BKCommandStatus)status;
//下拉刷新、上拉加载更多
- (void)bkvm_configRefreshEnable:(BOOL)enable;
- (void)bkvm_setPullUpRefreshEnable:(BOOL)enable;
- (void)bkvm_setPullDownRefreshEnable:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END
