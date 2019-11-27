//
//  NSObject+BKVMDelegator.h
//  Pods
//
//  Created by lic on 2019/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BKVMDelegator)

@property (nonatomic, weak) id rawDelegate;

@end

NS_ASSUME_NONNULL_END
