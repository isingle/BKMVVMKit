//
//  BKCommandResponsess.m
//  SUIMVVMDemo
//
//  Created by lic on 2019/8/21.
//  Copyright © 2019 BK. All rights reserved.
//

#import "BKCommandResponse.h"

@implementation BKCommandResponse
- (instancetype)initCommandResponse:(id _Nullable)response parserModel:(Class _Nullable)parserModel error:(NSError *)error {
    if ([super init]) {
        if ([response isKindOfClass:parserModel]) {
            self.content = response;
            self.error = error;
        }
    }
    return self;
}
- (instancetype)initCommandResponse:(id _Nullable)response error:(NSError * _Nullable)error {
    if ([super init]) {
        if (response) {
            self.content = response;
            self.error = error;
        }
    }
    return self;
}

@end
