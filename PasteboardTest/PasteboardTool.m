//
//  PasteboardTool.m
//  MHJFamilyChatV1
//
//  Created by tangmi on 16/5/9.
//  Copyright © 2016年 tangmi. All rights reserved.
//

#import "PasteboardTool.h"


@implementation PasteboardTool
{
    UIPasteboard * _myPasteboard;
    NSString * _name;
    NSDictionary * _jsonDic;
    NSDictionary * _shareDic;
}
static PasteboardTool *tool = nil;

+ (instancetype)shareTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[PasteboardTool alloc]init];
        [tool initPasteboard:SHAREBOARD];
    });
    return tool;
}



- (void)initPasteboard:(NSString*)name
{
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:name create:YES];
    pasteboard.persistent = YES;
    _myPasteboard = pasteboard;
//    [[NSNotificationCenter defaultCenter] addObserver:tool selector:@selector(handleNotification:) name:UIPasteboardChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:tool selector:@selector(handleNotification:) name:UIPasteboardRemovedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:tool selector:@selector(handleNotification:) name:UIPasteboardChangedTypesAddedKey object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:tool selector:@selector(handleNotification:) name:UIPasteboardChangedTypesRemovedKey object:nil];
    
    
}

//- (void)handleNotification:(NSNotification*)noti
//{
//    NSLog(@"%@",noti);
//    NSString *name = noti.name;
//    if ([name isEqualToString:UIPasteboardRemovedNotification]) {
//        UIPasteboard *pasteboard = noti.object;
//        if (self.delegate&&[self.delegate respondsToSelector:@selector(didDeletePasteboard:)]) {
//            [self.delegate didDeletePasteboard:pasteboard];
//        }
//    }else if ([name isEqualToString:UIPasteboardChangedTypesAddedKey]){
//        
//    }else if ([name isEqualToString:UIPasteboardChangedTypesRemovedKey]){
//        
//    }else if ([name isEqualToString:UIPasteboardChangedNotification]){
//        
//    }
//}


- (void)saveDic:(NSDictionary*)dic forKey:(NSString*)key
{
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [_myPasteboard setData:dictData forPasteboardType:key];
}

- (void)saveStr:(NSString *)str forKey:(NSString *)key
{
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:str];
    [_myPasteboard setData:dictData forPasteboardType:key];
}

- (void)saveData:(NSData *)data forKey:(NSString *)key{
    
    [_myPasteboard setData:data forPasteboardType:key];
    
}

- (id)dataForKey:(NSString *)key{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[_myPasteboard dataForPasteboardType:key]];
    
}

- (void)clear{
    //    [UIPasteboard removePasteboardWithName:SHAREBOARD];
    //    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:SHAREBOARD create:YES];
    //    _myPasteboard = pasteboard;
    
    NSArray *types = [_myPasteboard pasteboardTypes];
    for (NSString *type in types) {
        if ([type isEqualToString:STATE]) {
            return;
        }
        NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:@0];//这里clear的数据类型可以自己定义 
        [_myPasteboard setValue:dictData forPasteboardType:type];
    }
}

#pragma Login

- (BOOL)saveLoginDataToLocal{
    
    //我这里写的是存储登录数据的逻辑，因为登录数据是固定的,这里是存入本地
    
    return YES;
    
}

- (BOOL)saveLoginDataToPasteboard{

    //我这里写的是存储登录数据的逻辑，因为登录数据是固定的,这里是存入剪贴板
    
    return NO;
}

#pragma share

- (void)saveShareDataToPasteboard:(int)friendID andDevices:(NSArray *)array {
    
    
    //我这里写的是app跳转时所传输的数据，我传输的是分享数据，需要ID和array，你们可以修改此方法；
    
}


- (void)clearShareData{
    
    //这里是清空这个分享数据   这里只是提供这种思路  用的人可以自行定义
    [self saveShareDataToPasteboard:0 andDevices:nil];
}

#pragma appstate

- (void)saveAPP:(NSString *)appName state:(KMHJAPPState)state{
    
    //app状态存储 你可以自己定义
    NSMutableDictionary *jsonDic = [NSMutableDictionary new];
    NSDictionary *dic = [self dataForKey:STATE];
    if (dic.allKeys.count == 2 || dic.allKeys.count == 1) {
        for (NSString *name in dic.allKeys ) {
            if ([name isEqualToString:appName]) {
                [jsonDic setObject:[NSNumber numberWithInteger:state] forKey:appName];
            }else{
                [jsonDic setObject:[dic objectForKey:name] forKey:name];
            }
        }
    }else if (dic.allKeys.count == 0){
        [jsonDic setObject:[NSNumber numberWithInteger:state] forKey:appName];
    }
    
    
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:jsonDic];
    [_myPasteboard setData:dictData forPasteboardType:STATE];
}

- (int)AppStateByName:(NSString *)appname{
    
    //取出app状态  你自己定义
    NSDictionary *dic = [self dataForKey:STATE];
    for (NSString *name in dic.allKeys )
    {
        if ([name isEqualToString:appname]) {
            return [[dic objectForKey:name] intValue];
        }
    }
    return 0;
}

#pragma value 取值

- (NSDictionary *)loginData{
    if (_jsonDic) {
        return _jsonDic;
    }else{
        NSLog(@"无登陆数据");
        return nil;
    }
}

//- (NSDictionary *)shareData{
//    NSDictionary *dic = [self dataForKey:SHARE];
//    _shareDic = dic;
//    NSLog(@"SHARE = %@",dic);
//    return dic;
//}

#pragma skip 跳转

//用于快速获取跳转string  自己定义吧

+ (NSString *)skipStringHeader:(NSString *)str Mode:(KMHJSkipMode)mode{
    
    NSString *string = [NSString stringWithFormat:@"%@%ld",str,(long)mode];
    return string;
    
}


@end
