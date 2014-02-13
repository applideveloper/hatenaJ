//
//  popularFetcher.m
//  hatenaJ
//
//  Created by Nagasawa Hiroki on 2014/02/11.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import "popularFetcher.h"
#import "DDXMLElement+Dictionary.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "DDXMLElement+Dictionary.h"


@implementation popularFetcher

- (void)beginFetchPopularList:(void (^)(NSDictionary *result, NSError *error)) completionHandler
{
    NSLog(@"fetch_start");
    
     NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://b.hatena.ne.jp/hotentry?mode=rss"]];
     
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
     
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSError *error = nil;
     DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:&error];
     if (!error) {
     NSDictionary *xml = [doc.rootElement convertDictionary];
         if (completionHandler) {
             completionHandler(xml, error);
         }
     } else {
         NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
     }];
     
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
     [queue addOperation:operation];    
}

@end
