//
//  PlaceModel.m
//  TableViewRightIndex_Demo
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel


-(instancetype)initWithNameStr:(NSString *)nameStr
{
    if(self =[super init]){
        self.name = nameStr;

    }
    return self;
}

@end
