//
//  BKPinCellViewModel.m
//  BKMVVMKit_Example
//
//  Created by lic on 2019/9/30.
//  Copyright © 2019 isingle. All rights reserved.
//

#import "BKPinCellViewModel.h"
#import "BKPinCollectionViewCell.h"

@implementation BKPinCellViewModel

- (NSString *)identifier {
    return [BKPinCollectionViewCell identifier];
}

- (Class<BKVMViewProtocol>)viewClass {
    return [BKPinCollectionViewCell class];
}

@end
