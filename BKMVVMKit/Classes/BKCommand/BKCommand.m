//
//  BK_Command.m
//  SUIMVVMDemo
//
//  Created by lic on 2019/8/8.
//  Copyright © 2019 BK. All rights reserved.
//

#import "BKCommand.h"

@interface BKCommand ()
@property (nonatomic, copy) BKCommandExecutedBlock executedBlock;
@property (nonatomic, copy) BKCommandCancelBlock cancelBlock;
@end

@implementation BKCommand

- (instancetype)initWithCommandHandler:(BKCommandExecutedBlock)executedHandler cancelHandler:(BKCommandCancelBlock)cancelBlock {
    if ([super init]) {
        _executedBlock = executedHandler;
        _cancelBlock = cancelBlock;
        _response = nil;
    }
    return self;
}

- (void)execute:(BKCommandEntry * _Nullable)entry {
    self.entry = entry;
    [self execute];
}

- (void)execute {
    if (BKCommandStatusExecuting == self.status) {
        return;
    }
    self.status = BKCommandStatusExecuting;
    if (self.finishedHandler == nil) {
        __weak typeof(self) weakSelf = self;
        self.finishedHandler = ^(id  _Nullable error, id  _Nonnull content, BKCommandStatus status) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.status = status;
            if (error) {
                strongSelf.response = [[BKCommandResponse alloc] initCommandResponse:nil error:error];
            } else {
                strongSelf.response = [[BKCommandResponse alloc] initCommandResponse:content error:nil];
            }
        };
    }
    if (self.executedBlock) {
        self.executedBlock(self.entry, self.finishedHandler);
    }
}

- (void)cancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    self.status = BKCommandStatusCancelled;
}

@end
