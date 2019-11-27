//
//  BKVMBaseViewModel.m
//  basic_plugin
//
//  Created by lic on 2019/8/27.
//

#import "BKVMBaseViewModel.h"

@interface BKVMBaseViewModel ()
@end

@implementation BKVMBaseViewModel

- (instancetype)initWithModel:(id)model {
    if ([super init]) {
        _rawModel = model;
    }
    return self;
}

@end
