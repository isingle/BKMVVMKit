//
//  NSObject+BKVMDelegator.m
//  Pods
//
//  Created by lic on 2019/9/5.
//

#import "NSObject+BKVMDelegator.h"
#import <objc/runtime.h>

static void *rawDelegateKey = &rawDelegateKey;

@implementation NSObject (BKVMDelegator)

- (id)rawDelegate {
    id delegate = objc_getAssociatedObject(self, rawDelegateKey);
    return delegate;
}

- (void)setRawDelegate:(id)rawDelegate {
    objc_setAssociatedObject(self, rawDelegateKey, rawDelegate, OBJC_ASSOCIATION_ASSIGN);
}

@end
