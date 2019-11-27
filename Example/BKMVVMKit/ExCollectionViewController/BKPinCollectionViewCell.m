//
//  BKPinCollectionViewCell.m
//  BKMVVMKit_Example
//
//  Created by lic on 2019/9/24.
//  Copyright © 2019 isingle. All rights reserved.
//

#import "BKPinCollectionViewCell.h"
#import "BKExHeader.h"
#import "BKPinCellViewModel.h"
#import "NSObject+BKVMDelegator.h"

@interface BKPinCollectionViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *roleNameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) BKPinCellViewModel *cellVm;

@end

@implementation BKPinCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - binder BKVMViewProtocol
- (void)bkvm_binderWithViewModel:(BKPinCellViewModel *)viewModel {
    self.cellVm = viewModel;
    _roleNameLabel.text = viewModel.roleName;
}

+ (CGFloat)bkvm_viewWidthWithViewModel:(__kindof BKVMBaseViewModel *)viewModel {
    return 300;
}

+ (CGFloat)bkvm_viewHeightWithViewModel:(__kindof BKVMBaseViewModel *)viewModel {
    return 200;
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.textField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textLengthChange:(id)sender {
    if (self.rawDelegate) {
        if ([self.rawDelegate respondsToSelector:@selector(changeTitle:)]) {
            [self.rawDelegate changeTitle:self.textField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.roleNameLabel];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 120, 30)];
    self.textField.placeholder = @"hi...";
    self.textField.font = [UIFont systemFontOfSize:13];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.contentView addSubview:self.textField];
}

- (UILabel *)roleNameLabel
{
    if (!_roleNameLabel) {
        _roleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
        _roleNameLabel.font = BKVM_FONT(15);
    }
    return _roleNameLabel;
}

@end
