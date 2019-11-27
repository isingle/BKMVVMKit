//
//  BKVMReusableViewModel.h
//  Pods
//
//  Created by lic on 2019/9/4.
//

#import "BKVMBaseViewModel.h"
#import "BKVMViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKVMReusableViewModel : BKVMBaseViewModel
//子类实现注册 reuse cell
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) Class<BKVMViewProtocol> viewClass;
//
@property (nonatomic, assign, readonly) CGFloat viewHeight;
@property (nonatomic, assign, readonly) CGFloat viewWidth;

- (instancetype)initWithModel:(id)model identifier:(NSString *)identifier viewClass:(Class<BKVMViewProtocol>)viewClass;

@end

NS_ASSUME_NONNULL_END
