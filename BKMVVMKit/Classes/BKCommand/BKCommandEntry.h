//
//  BKCommandEntry.h
//  SUIMVVMDemo
//
//  Created by lic on 2019/8/22.
//  Copyright © 2019 BK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCommandEntry : NSObject

@property (nonatomic, strong, readonly) id parameter;
@property (nonatomic, strong, readonly) id url;
@property (nonatomic, strong, readonly) Class parserModel;
@property (nonatomic, strong, readonly) Class urlConfigClass;
@property (nonatomic, strong, readonly) id target;
@property (nonatomic, copy, readonly) NSString *urlPath;
@property (nonatomic, assign, readonly) BOOL needCache;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initEntryWithParameter:(id _Nullable)parameter;
- (instancetype)initEntryWithURL:(id _Nullable)url target:(id)target;
- (instancetype)initEntryWithURL:(id _Nullable)url target:(id)target urlConfigClass:(Class _Nullable)configClass;
/**
 初始化一个 command

 @param url URL
 @param target target description
 @param configClass 支持配置了URLBaseConfig
 @param parameter 参数
 @param parserModel 解析model
 @return return value description
 */
- (instancetype)initEntryWithURL:(id _Nullable)url target:(id _Nullable)target urlConfigClass:(Class _Nullable)configClass parameter:(id _Nullable)parameter parserModel:(Class _Nullable)parserModel NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
