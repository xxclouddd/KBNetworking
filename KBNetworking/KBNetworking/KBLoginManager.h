//
//  KBLoginManager.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBAPIBaseManager.h"

@interface KBLoginManager : KBAPIBaseManager<KBAPIManager, KBAPIManagerValidator>

- (void)loginWithAccout:(NSString *)account
              password:(NSString *)password
             completion:(void(^)(NSDictionary *JSON, NSError *error))completion;

@end
