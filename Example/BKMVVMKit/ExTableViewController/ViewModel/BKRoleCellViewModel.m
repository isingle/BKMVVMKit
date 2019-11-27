//
//  BKRoleCellViewModel.m
//  Pods
//
//  Created by lic on 2019/8/27.
//

#import "BKRoleCellViewModel.h"
#import "UITableViewCell+BKVMConfig.h"
#import "BKVMViewProtocol.h"
#import "BKColorModel.h"
#import "BKRoleCell.h"

@interface BKRoleCellViewModel ()
@property (nonatomic, strong) BKColorModel *colorModel;
@end

@implementation BKRoleCellViewModel

- (instancetype)initWithModel:(id)model {
    if ([super initWithModel:model]) {
        _colorModel = (BKColorModel *)self.rawModel;
    }
    return self;
}

- (instancetype)initWithModel:(id)model identifier:(NSString *)identifier viewClass:(Class<BKVMViewProtocol>)viewClass {
    if ([super initWithModel:model identifier:identifier viewClass:viewClass]) {
        _colorModel = (BKColorModel *)self.rawModel;
    }
    return self;
}

- (NSString *)roleName {
    return self.colorModel.colorName;
}

- (void)setRoleName:(NSString *)roleName {
    self.colorModel.colorName = roleName;
}

- (NSString *)identifier {
    return [BKRoleCell identifier];
}

- (Class<BKVMViewProtocol>)viewClass {
    return [BKRoleCell class];
}

@end
