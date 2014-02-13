//
//  DetailViewController.h
//  hatenaJ
//
//  Created by Nagasawa Hiroki on 2014/02/11.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSMutableArray* detailItem;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
