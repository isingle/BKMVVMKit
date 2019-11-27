//
//  BKRoleCell.m
//  Pods
//
//  Created by lic on 2019/9/11.
//

#import "BKRoleCell.h"
#import "BKRoleCellViewModel.h"
#import "KVOController.h"
#import "BKExHeader.h"
#import "NSObject+BKVMDelegator.h"

@interface BKRoleCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *roleNameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) BKRoleCellViewModel *cellVm;

@end

@implementation BKRoleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50);
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    [self addSubview:self.roleNameLabel];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(200, 20, 120, 30)];
    self.textField.placeholder = @"hi...";
    self.textField.font = [UIFont systemFontOfSize:13];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:self.textField];
}

- (UILabel *)roleNameLabel {
    if (!_roleNameLabel) {
        _roleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 15, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 18*2 -28, 20)];
        _roleNameLabel.font = BKVM_FONT(15);
    }
    return _roleNameLabel;
}

#pragma mark - binder BKVMViewProtocol
- (void)bkvm_binderWithViewModel:(BKRoleCellViewModel *)viewModel {
    self.cellVm = viewModel;
    _roleNameLabel.text = viewModel.roleName;
}

+ (CGFloat)bkvm_viewHeightWithViewModel:(BKRoleCellViewModel *)viewModel {
    //可动态计算高度
    return 60;
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

@end
