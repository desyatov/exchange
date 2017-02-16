//
//  ModelBase.m
//  exchange
//
//  Created by Alexander Desyatov on 11/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ModelBase.h"

@implementation ModelBase

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self DefaultJSONKeyPathsByPropertyKey];
}

+ (NSDictionary *)DefaultJSONKeyPathsByPropertyKey
{
    return [[self propertyKeys].allObjects reduce:^id(id carry, id object) {
        NSMutableDictionary *dic = carry ? : [NSMutableDictionary dictionary];
        [dic setValue:object forKey:object];
        return dic;
    }];
}

@end
