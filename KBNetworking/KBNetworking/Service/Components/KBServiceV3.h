//
//  KBServiceV3.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBService.h"

@interface KBServiceV3 : KBService<KBServiceProtocal>

@property (nonatomic, copy, readonly) NSString *appId;

@end
