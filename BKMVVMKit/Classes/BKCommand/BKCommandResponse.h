//
//  BKCommandResponse.h
//  SUIMVVMDemo
//
//  Created by lic on 2019/8/21.
//  Copyright © 2019 BK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCommandResponse : NSObject

@property (nonatomic, strong) id content;
@property (nonatomic, strong) id error;

- (instancetype)initCommandResponse:(id _Nullable)response parserModel:(Class _Nullable)parserModel error:(NSError * _Nullable)error;
- (instancetype)initCommandResponse:(id _Nullable)response error:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
