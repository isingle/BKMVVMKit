//
//  BKVMReusableViewModel.m
//  Pods
//
//  Created by lic on 2019/9/4.
//

#import "BKVMReusableViewModel.h"

@interface BKVMReusableViewModel ()
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewWidth;
@end

@implementation BKVMReusableViewModel

- (instancetype)initWithModel:(id)model identifier:(NSString *)identifier viewClass:(Class<BKVMViewProtocol>)viewClass {
    if ([super initWithModel:model]) {
        self.identifier = identifier;
        self.viewClass = viewClass;
    }
    return self;
}

- (CGFloat)viewHeight {
    if ([self.viewClass respondsToSelector:@selector(bkvm_viewHeightWithViewModel:)]) {
        return [self.viewClass bkvm_viewHeightWithViewModel:self];
    }
    if ([[self.viewClass class] isSubclassOfClass:[UITableViewCell class]]) {
        return UITableViewAutomaticDimension;
    }
    return 0;
}

- (CGFloat)viewWidth {
    if ([self.viewClass respondsToSelector:@selector(bkvm_viewWidthWithViewModel:)]) {
        return [self.viewClass bkvm_viewWidthWithViewModel:self];
    }
    return 0;
}

@end
