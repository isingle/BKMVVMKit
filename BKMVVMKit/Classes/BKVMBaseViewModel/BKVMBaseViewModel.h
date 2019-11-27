//
//  BKVMBaseViewModel.h
//  basic_plugin
//
//  Created by lic on 2019/8/27.
//

#import <Foundation/Foundation.h>
#import "BKCommand.h"
#import "BKVMMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKVMBaseViewModel : NSObject

@property (nonatomic, strong) BKCommand *dataCommand;
@property (nonatomic, strong) id rawModel;
//绑定 model
- (instancetype)initWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
