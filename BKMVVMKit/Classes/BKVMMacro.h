//
//  BKMacro.h
//  Pods
//
//  Created by lic on 2019/9/11.
//

#ifndef BKMacro_h
#define BKMacro_h

#define BKVM_COMMAND_STATUS @"dataCommand.status"
#define BKVM_COMMAND_RESPONSE @"dataCommand.response.content"
#define BKVM_COLLECTION_OPERATION @"collectionOption"
#define BKVM_TABLE_OPERATION @"tableOperation"

#define BKVM_WEAKSELF() __weak __typeof(&*self) weakSelf = self
#define BKVM_STRONGSELF() __strong typeof(weakSelf) strongSelf = weakSelf

#define BKVM_STRING_LOADING @"正在加载"
#define BKVM_STRING_CANCEL_LOADING @"加载已取消"
#define BKVM_STRING_FETCH_FAIL @"加载失败，请稍候再试"

#endif /* BKMacro_h */
