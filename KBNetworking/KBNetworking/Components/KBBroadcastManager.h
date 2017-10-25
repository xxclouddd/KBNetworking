//
//  KBBroadcastManager.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 16/1/25.
//  Copyright © 2016年 KuaidiHelp. All rights reserved.
//

#import "KBAutoRefreshSessionAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const KBBroadcastTypeActionGet;
extern NSString * const KBBroadcastTypeScan;

@interface KBBroadcastManager : KBAutoRefreshSessionAPIManager<KBAPIManager, KBAPIManagerValidator>

- (void)getInformBroadcastWithAction:(NSString *)action type:(NSString *)type completionHandle:(void(^)(NSString * _Nullable broadcast, NSError * _Nullable error))completionHandle;

@end

NS_ASSUME_NONNULL_END