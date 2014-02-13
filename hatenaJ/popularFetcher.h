//
//  popularFetcher.h
//  hatenaJ
//
//  Created by Nagasawa Hiroki on 2014/02/11.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface popularFetcher : NSObject

@property (nonatomic, weak) NSMutableArray *titleArr;
@property (nonatomic, weak) NSMutableArray *linkArr;
@property (nonatomic, weak) NSMutableArray *descriptionArr;
@property (nonatomic, weak) NSMutableArray *entryImageArr;
@property (nonatomic, weak) NSMutableArray *hatenaCount;

- (void)beginFetchPopularList:(void (^)(NSDictionary *result, NSError *error)) completionHandler;

@end
