//
//  BK_Command.h
//  SUIMVVMDemo
//
//  Created by lic on 2019/8/8.
//  Copyright © 2019 BK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKCommandResponse.h"
#import "BKCommandEntry.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BKCommandStatusDefault = 0,
    BKCommandStatusExecuting,   //执行中
    BKCommandStatusSuccessed,   //执行成功
    BKCommandStatusFailed,      //执行失败
    BKCommandStatusCancelled,    //命令取消
} BKCommandStatus; //命令执行状态

//命令完成,返回数据
typedef void(^BKCommandFinishedBlock)(id _Nullable error, id _Nullable content, BKCommandStatus status);
//命令执行
typedef void(^BKCommandExecutedBlock)(BKCommandEntry * _Nullable entry, BKCommandFinishedBlock finishedHandler);
//命令取消
typedef void(^BKCommandCancelBlock)(void);

@interface BKCommand : NSObject
@property (nonatomic, strong) BKCommandResponse *response;
@property (nonatomic, assign) BKCommandStatus status;
@property (nonatomic, copy) BKCommandFinishedBlock finishedHandler;
@property (nonatomic, strong) BKCommandEntry *entry;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithCommandHandler:(BKCommandExecutedBlock)executedHandler cancelHandler:(BKCommandCancelBlock)cancelBlock NS_DESIGNATED_INITIALIZER;

/**
 执行具体命令

 @param entry 自定义命令
 */
- (void)execute:(BKCommandEntry * _Nullable)entry;
- (void)execute;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
