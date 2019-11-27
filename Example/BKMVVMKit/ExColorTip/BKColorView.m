//
//  BKColorView.m
//  Pods
//
//  Created by lic on 2019/9/6.
//

#import "BKColorView.h"
#import "BKColorViewModel.h"
#import "KVOController.h"
#import "BKColorViewModel.h"

@interface BKColorView ()
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation BKColorView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.tipLabel];
        self.viewModel = [[BKColorViewModel alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self.KVOController observe:self.viewModel keyPath:@"curColorName" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            id value = change[NSKeyValueChangeNewKey];
            if (value) {
                [self bkvm_binderWithViewModel:self.viewModel];
            }
        }];
    }
    return self;
}

- (void)bkvm_binderWithViewModel:(__kindof BKVMBaseViewModel *)viewModel {
    BKColorViewModel *vm = (BKColorViewModel *)viewModel;
    self.tipLabel.text = vm.curColorName;
    self.backgroundColor = vm.bgColor;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _tipLabel.text = @"显示选择的颜色";
        _tipLabel.textColor = [UIColor orangeColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
@end
