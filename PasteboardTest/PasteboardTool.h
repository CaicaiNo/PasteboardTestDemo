//
//  PasteboardTool.h
//  MHJFamilyChatV1
//
//  Created by tangmi on 16/5/9.
//  Copyright © 2016年 tangmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//此处为app跳转模式的枚举
typedef NS_ENUM(NSInteger,KMHJSkipMode) {
    KMHJSkipSend = 101, //请求
    KMHJSkipShareReturn = 102, //分享回执
    KMHJSkipDeleteReturn = 103, //删除回执
    KMHJSkipLogin = 104, //从另一APP登录
    KMHJSkipLoginReturn = 105,
    KMHJSkipLogout = 106, //同步登出
    KMHJSkipLogoutReturn = 107,
    KMHJSkipNormal = 100, //普通跳转
};
//此处为app状态，用于跳转判断，没登录怎么办，登录了怎么办，避免多余的跳转操作
typedef NS_ENUM(NSInteger,KMHJAPPState) {
    KMHJAPPLogin = 0,
    KMHJAPPOffline = 1,
    
};


#warning 你需要自己写剪贴板名字
#define SHAREBOARD @"" //剪贴板名 名字规范为Bundle id 的前缀com.company 例如:com.company.pasteboardname
//你可以自己宏定义几个常用type
#define STATE @"appState" //app状态


#warning 代理监听方法 - 只能监听一个app的操作

//@protocol PasteboardDelegate <NSObject>
//
//- (void)didChangedPasteboard:(UIPasteboard*)board;
//
//- (void)didDeletePasteboard:(UIPasteboard*)board;
//
//- (void)pasteboard:(UIPasteboard*)board didAddPasteboardType:(NSString*)type;
//
//- (void)pasteboard:(UIPasteboard*)board didRemovePasteboardType:(NSString*)type;
//
//@end


@interface PasteboardTool : NSObject

//@property (nonatomic, weak) id <PasteboardDelegate>delegate;

#pragma mark - public methods

+ (instancetype)shareTool; //单例方法

- (void)initPasteboard:(NSString*)name;

- (void)saveDic:(NSDictionary*)dic forKey:(NSString*)key;

- (void)saveStr:(NSString *)str forKey:(NSString*)key;

- (void)saveData:(NSData *)data forKey:(NSString*)key;

- (id)dataForKey:(NSString *)key;

- (void)clear;

#pragma Login

- (BOOL)saveLoginDataToLocal;  //这里固定存储登录数据逻辑

- (BOOL)saveLoginDataToPasteboard; //

#pragma share

- (void)saveShareDataToPasteboard:(int)friendID andDevices:(NSArray *)array;

- (void)clearShareData;

#pragma appstate

- (void)saveAPP:(NSString *)appName state:(KMHJAPPState)state;

- (int)AppStateByName:(NSString *)appname;

#pragma value 取值

- (NSDictionary *)loginData;

//- (NSDictionary *)shareData;

#pragma skip 跳转

+ (NSString *)skipStringHeader:(NSString *)str Mode:(KMHJSkipMode)mode;


@end
