//
//  PlaceModel.h
//  TableViewRightIndex_Demo
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject

-(instancetype)initWithNameStr:(NSString *)nameStr;

@property (assign, readwrite, nonatomic) NSString *name;


@end
