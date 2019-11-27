//
//  BKRoleCell.h
//  Pods
//
//  Created by lic on 2019/9/11.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+BKVMConfig.h"
#import "BKVMViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RoleSelectedDelegate <NSObject>

- (void)changeTitle:(NSString *)title;

@end

@interface BKRoleCell : UITableViewCell<BKVMViewProtocol>

@end

NS_ASSUME_NONNULL_END
