//
//  SummaryTableViewCell.m
//  SGExpense
//
//  Created by Hu Jianbo on 17/5/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "SummaryTableViewCell.h"

@implementation SummaryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
