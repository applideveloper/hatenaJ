//
//  ListViewCell.h
//  hatenaJ
//
//  Created by Nagasawa Hiroki on 2014/02/11.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *entryImageView;

@end
