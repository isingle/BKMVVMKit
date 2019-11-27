//
//  BKCommandEntry.m
//  SUIMVVMDemo
//
//  Created by lic on 2019/8/22.
//  Copyright © 2019 BK. All rights reserved.
//

#import "BKCommandEntry.h"
@interface BKCommandEntry ()

@property (nonatomic, strong) id parameter;
@property (nonatomic, strong) id url;
@property (nonatomic, strong) Class parserModel;
@property (nonatomic, strong) Class urlConfigClass;
@property (nonatomic, strong) id target;
@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, assign) BOOL needCache;
@end

@implementation BKCommandEntry

- (instancetype)initEntryWithParameter:(id _Nullable)parameter {
    return [self initEntryWithURL:nil target:nil urlConfigClass:nil parameter:parameter parserModel:nil];
}
- (instancetype)initEntryWithURL:(id _Nullable)url target:(id)target {
    return [self initEntryWithURL:url target:target urlConfigClass:nil];
}
- (instancetype)initEntryWithURL:(id _Nullable)url target:(id)target urlConfigClass:(Class _Nullable)configClass {
    return [self initEntryWithURL:url target:target urlConfigClass:configClass parameter:nil parserModel:nil];
}

- (instancetype)initEntryWithURL:(id _Nullable)url target:(id _Nullable)target urlConfigClass:(Class _Nullable)configClass parameter:(id _Nullable)parameter parserModel:(Class _Nullable)parserModel {
    if ([super init]) {
        _url = url;
        _target = target;
        _urlConfigClass = configClass;
        _parserModel = parserModel;
        _parameter = parameter;
    }
    return self;
}

@end
