//
//  BKVMCollectionController.h
//  Pods
//
//  Created by lic on 2019/9/9.
//

#import <UIKit/UIKit.h>
#import "BKVMViewProtocol.h"
#import "UICollectionView+BKVMConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BKVMCollectionDelegate <NSObject>
@optional
//regist view for item
- (void)bkvm_registerItemWithIdentifier:(NSString *)identifier;

//regist view for header
- (void)bkvm_registerSectionHeaderWithIdentifier:(NSString *)identifier;

//regist view for footer
- (void)bkvm_registerSectionFooterWithIdentifier:(NSString *)identifier;

@end

@interface BKVMCollectionController : UIViewController <BKVMViewProtocol, BKVMCollectionDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, weak) id<BKVMCollectionDelegate>delegate;
//执行状态, 子类重载
- (void)showExecuteStatus:(BKCommandStatus)status;
@end

NS_ASSUME_NONNULL_END
