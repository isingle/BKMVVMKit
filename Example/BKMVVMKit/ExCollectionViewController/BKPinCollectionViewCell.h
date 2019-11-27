//
//  BKPinCollectionViewCell.h
//  BKMVVMKit_Example
//
//  Created by lic on 2019/9/24.
//  Copyright © 2019 isingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewCell+BKVMConfig.h"
#import "BKVMViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BKPinSelectedDelegate <NSObject>

- (void)changeTitle:(NSString *)title;

@end

@interface BKPinCollectionViewCell : UICollectionViewCell<BKVMViewProtocol>

@end

NS_ASSUME_NONNULL_END
