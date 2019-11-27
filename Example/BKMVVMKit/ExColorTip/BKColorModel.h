//
//  BKColorModel.h
//  Pods
//
//  Created by lic on 2019/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKColorModel : NSObject
@property (nonatomic, copy) NSString *colorName;
@property (nonatomic, assign) BOOL isSelected;
- (instancetype)initTitle:(NSString *)title isSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
