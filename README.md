# BKMVVMKit

BKMVVMKit is a design pattern based on MVVM, with the purpose of data-driven UI for iOS GUI framework; It is able to solve the problems caused by too bloated ViewController, such as poor maintenance and testability, and it is compatible with existing MVC framework.

详细介绍请查看:  [https://zhuanlan.zhihu.com/p/94370337](https://zhuanlan.zhihu.com/p/94370337)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+
- CocoaPods 1.0+

## Installation

BKMVVMKit is available through [CocoaPods](https://cocoapods.org). To installit, simply add the following line to your Podfile:

```ruby
pod 'BKMVVMKit'
```

# Architecture

BKMVVMKit 框架的设计模式如下图：

![Image text](https://s1.ax1x.com/2020/03/12/8ZSvlt.png)

可以看到在框架中有一个 BKCommand ， ViewModel 可以持有多个 BKCommand 对象，并可以向它发送指令，接下来我们先聊一聊 BKCommand。

## BKCommand

​	BKCommand 的作用是接收到命令并触发动作执行，然后返回命令执行状态和结果，一般是跟 UI 交互操作相关，也可以处理单纯的业务逻辑。

![Image text](https://s1.ax1x.com/2020/03/12/8Z9QDf.png)

BKCommandEntry 是对命令实体的扩展描述，比如命令执行需要的 URL、Parameter 等，该实体也可以不进行配置；

BKCommandResponse 是命令执行返回的结果，其中包含了返回的 content 与 error 等属性，可以通过 KVO 这些属性，获取实时的执行结果；

```objective-c
typedef enum : NSUInteger {
    BKCommandStatusDefault = 0,
    BKCommandStatusExecuting,   //执行中
    BKCommandStatusSuccessed,   //执行成功
    BKCommandStatusFailed,      //执行失败
    BKCommandStatusCancelled,   //命令取消
} BKCommandStatus; //命令执行状态
```

对于一个命令来说，执行的状态是跟 UI 交互操作息息相关的，每个状态可能都需要通过 UI 传达给用户，例如：执行中的 Loading 提示，执行成功的状态回调等。

```objective-c
//命令完成,返回数据
typedef void(^BKCommandFinishedBlock)(id _Nullable error, id content, BKCommandStatus status);
//命令执行
typedef void(^BKCommandExecutedBlock)(BKCommandEntry * _Nullable entry, BKCommandFinishedBlock finishedHandler);
//命令取消
typedef void(^BKCommandCancelBlock)(void);
```

下面我们以一个加载列表的需求来看一下 BKCommand 的使用：

1. 首先在 ViewModel 中创建一个 BKCommand 对象

   ```objective-c
   self.dataCommand = [[BKCommand alloc] initWithCommandHandler:^(BKCommandEntry * _Nullable entry, BKCommandFinishedBlock  _Nonnull finishedHandler) {
               //业务逻辑,e.g:网络请求
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
   ​            finishedHandler(nil, sections, BKCommandStatusSuccessed);
   
   ​        });
   ​    } cancelHandler:^{
   ​    }];
   ```

2. 在 UI 交互触发后，通过下面的方法去执行命令

   ```objective-c
   BKCommandEntry *entry = [[BKCommandEntry alloc] initEntryWithURL:@"http://demo.com" target:self];
   [self.dataCommand execute:entry];
   ```

3. dataCommand 的执行流程

   ```objective-c
   - (void)execute:(BKCommandEntry * _Nullable)entry {
       self.entry = entry;
       [self execute];
   }
   
   - (void)execute {
       if (BKCommandStatusExecuting == self.status) {
           return;
       }
       self.status = BKCommandStatusExecuting;
       if (self.finishedHandler == nil) {
           __weak typeof(self) weakSelf = self;
           self.finishedHandler = ^(id  _Nullable error, id  _Nonnull content, BKCommandStatus status) {
               __strong typeof(self) strongSelf = weakSelf;
               strongSelf.status = status;
               if (error) {
                   strongSelf.response = [[BKCommandResponse alloc] initCommandResponse:nil error:error];
               } else {
                   strongSelf.response = [[BKCommandResponse alloc] initCommandResponse:content error:nil];
               }
           };
       }
       if (self.executedBlock) {
           self.executedBlock(self.entry, self.finishedHandler);
       }
   }
   ```

   每个指令的执行状态都是从这个方法中获取的，`status`  这个属性是在 View 中被 Observe 的，页面加载的 Loading，Dialog 等交互 UI 可以根据该属性去更新。`finishedHandler` 是用来接收指令返回结果，更新 `response` 的值，Observe 了这个属性的 View 会被触发相关操作。

4. View 更新

   指令被触发后，随着被 Observe 的 `status` 属性值发生了变化，接着就会触发下面 Block 中的操作：

   ```objective-c
   //监听指令执行状态，处理交互    
       __weak typeof(self) weakSelf = self;
   ​ 	[self.KVOController observe:self.viewModel keyPath:BKVM_COMMAND_STATUS options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
   ​       id value = change[NSKeyValueChangeNewKey];
           if (value && ![value isEqual:[NSNull null]]) {
               __strong typeof(weakSelf) strongSelf = weakSelf;
               BKCommandStatus status = [value integerValue];
               [strongSelf showExecuteResultWithStatus:status];
           }
   ​    }];
   //子类可以重写
   - (void)showExecuteResultWithStatus:(BKCommandStatus)status {
       switch (status) {
        case BKCommandStatusExecuting:
               [[LJProgressHUDHelper getInstance] showWithStatus:BKVM_STRING_LOADING onView:self.view];
            break;
           case BKCommandStatusSuccessed:
            [[LJProgressHUDHelper getInstance] dismissOnView:self.view];
               break;
           case BKCommandStatusFailed:
               [[LJProgressHUDHelper getInstance] showInfoWithStatus:BKVM_STRING_FETCH_FAIL onView:self.view];
               break;
           case BKCommandStatusCancelled:
               [[LJProgressHUDHelper getInstance] showInfoWithStatus:BKVM_STRING_CANCEL_LOADING onView:self.view];
               break;
           default:
               [[LJProgressHUDHelper getInstance] dismissOnView:self.view];
               break;
       }
   }
   ```

   这里的 `showExecuteResultWithStatus:`  方法可以被子类重写，把指令的执行状态传递给 UI 交互。

   第三步中 command 执行完成后 `response` 的值也发生了变化，此时应该要对新接收到的数据进行加载了，可以看到最终会调用 `handleWithChanged:` 方法，根据 `BKVMTableOperation` 去执行对应的 UI 更新：

   ```objective-c
   //监听数据变化
   ​    [self.KVOController observe:self.viewModel keyPath:BKVM_COMMAND_RESPONSE options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
   ​       __strong typeof(weakSelf) strongSelf = weakSelf;
           [strongSelf tableViewEndRefreshing];
           id value = change[NSKeyValueChangeNewKey];
           if (value && ![value isEqual:[NSNull null]]) {
               if (strongSelf.viewModel.dataCommand.response.content) {
                   [strongSelf.listTableView bkvm_registerCellWithViewModel:strongSelf.viewModel];
                   [strongSelf handleWithChanged:BKVMTableOperationInital];
               }
           }
           [strongSelf showExecuteTip:strongSelf.viewModel];
       }];
   //更新 UI
   - (void)handleWithChanged:(BKVMTableOperation)operation {
       switch (operation) {
           case BKVMTableOperationInital:
           case BKVMTableOperationRefresh:
           {
               [self.listTableView reloadData];
               break;
           }
           case BKVMTableOperationAdd:
               [self.listTableView insertRowsAtIndexPaths:self.viewModel.indexPaths withRowAnimation:UITableViewRowAnimationFade];
               break;
           default:
               break;
       }
   }
   ```

以上就是 BKCommand 的用法，比较简单，可以看到我们所有的 KVO 操作都是对 BKCommand 进行的，这样也方便把状态通过 BKCommand 去转发，统一将不同格式的数据进行再次加工来满足业务的需求，调试起来也会比较容易。整体的流程如下图：

![Image text](https://s1.ax1x.com/2020/03/12/8Vzs5d.jpg)

## BKVMBaseViewModel

​	BKVMBaseViewModel 是所有 ViewModel 的父类，具体接口如下：

```objective-c
@interface BKVMBaseViewModel : NSObject
//默认command，子类也可以自行定义
@property (nonatomic, strong) BKCommand *dataCommand;
//model
@property (nonatomic, strong) id rawModel;
//绑定 model
- (instancetype)initWithModel:(id)model;
@end
```

## BKVMViewProtocol

​	我们把一些 View 需要去实现的方法放到了 BKVMViewProtocol 中，本意上是想让 View 一些约束，必须遵守一些协议，适当的约束在框架中会使得结构更为清晰：

```objective-c
@protocol BKVMViewProtocol <NSObject>

/**
 bind viewModel --> view
 @param viewModel viewModel
 */
- (void)bkvm_binderWithViewModel:(__kindof BKVMBaseViewModel * _Nonnull)viewModel;

@optional

/**
 view 计算高度
 @param viewModel viewModel
 @return height 
*/
+ (CGFloat)bkvm_viewHeightWithViewModel:(__kindof BKVMBaseViewModel * _Nonnull)viewModel;

/**
 view 计算宽度
 @param viewModel viewModel
 @return width
 */
+ (CGFloat)bkvm_viewWidthWithViewModel:(__kindof BKVMBaseViewModel * _Nonnull)viewModel;
@end
```

其中 `bkvm_binderWithViewModel:`是每个 View 必须要实现的方法，作用是在 View 容器中把 ViewModel 与 View 进行绑定。View 的高度、宽度计算方法是可选实现的，并通过 ViewModel 中的`viewHeight`，`viewWidth` 两个只读属性获取，例如：TableView 的行高计算如下：

```objective-c
//BKVMTableViewController 的 UITableViewDelegate 方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
​    BKVMReusableViewModel *viewModel = self.viewModel.sections[indexPath.section].cellViewModels[indexPath.row];
​    CGFloat height = viewModel.viewHeight;
​    return height;
}
```

```objective-c
//BKVMReusableViewModel 中 viewHeight get 方法
- (CGFloat)viewHeight {
​    if ([self.viewClass respondsToSelector:@selector(bkvm_viewHeightWithViewModel:)]) {
​        return [self.viewClass bkvm_viewHeightWithViewModel:self];
​    }
​    return [self.viewClass isKindOfClass:[UITableViewCell class]] ? UITableViewAutomaticDimension : 0;
}
```

最终通过在 TableViewCell 中实现下面的方法，获取高度值：

```objective-c
+ (CGFloat)bkvm_viewHeightWithViewModel:(BKRoleCellViewModel *)viewModel {
/**计算高度
	do something...
*/
​    return 60;
}
```



## Author

isingle@163.com

## License

BKMVVMKit is available under the MIT license. See the LICENSE file for more info.
