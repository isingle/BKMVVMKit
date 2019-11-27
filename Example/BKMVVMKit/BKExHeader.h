//
//  BKExHeader.h
//  BKMVVMKit_Example
//
//  Created by lic on 2019/10/14.
//  Copyright © 2019 isingle. All rights reserved.
//

#ifndef BKExHeader_h
#define BKExHeader_h

#define BKVM_UI_STATUSBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define BKVM_UI_NAVIGATIONBAR_HEIGHT 44.f
#define BKVM_UI_TABBAR_HEIGHT (IS_IPhoneXSeries ? (49.f+34.f) : 49.f)
#define BKVM_NAV_BAR_HEIGHT (BKVM_UI_STATUSBAR_HEIGHT + BKVM_UI_NAVIGATIONBAR_HEIGHT)
#define BKVM_SAFE_BOTTOM_WITHOUT_TABBAR (BKVM_UI_TABBAR_HEIGHT - 49.f)
#define BKVM_FONT(value) [UIFont systemFontOfSize:value]
#define BKVM_RECT(x, y, width, height) CGRectMake((x), (y), (width), (height))

#endif /* BKExHeader_h */
