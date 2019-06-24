pod "KBNetworking"

# <>引用不要使用#import <AFNetworking.h>
# 正确使用#import <AFNetworking/AFNetworking.h>
# 否则pod会报链接错误

#pod lib lint --sources=ssh://git@121.41.38.122:2020/xiaoxiong/gitdata/iOS/PrivatePodsRepository.git,https://github.com/CocoaPods/Specs.git --allow-warnings

#pod repo push PrivatePodsRepository KBNetworking.podspec --sources=ssh://git@121.41.38.122:2020/xiaoxiong/gitdata/iOS/PrivatePodsRepository.git,https://github.com/CocoaPods/Specs.git --allow-warnings

