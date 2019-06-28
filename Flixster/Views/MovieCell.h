//
//  MovieCell.h
//  Flixster
//
//  Created by selinons on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

NS_ASSUME_NONNULL_END
