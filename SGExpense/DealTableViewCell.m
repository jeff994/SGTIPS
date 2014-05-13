//
//  DealTableViewCell.m
//  SGExpense
//
//  Created by Hu Jianbo on 11/5/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell

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

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect tmpImgFrame = self.imageView.frame;
    CGFloat fValue = tmpImgFrame.size.height;
    CGFloat fImageWidth = tmpImgFrame.size.width;
    double fImageHeight = tmpImgFrame.size.height;
    self.imageView.frame = CGRectMake( 8, 0.2*fValue,  fValue, fValue *0.6);
    self.imageView.bounds = CGRectMake( 8, 0.2*fValue,  fValue, fValue *0.6);
    self.imageView.contentMode =   UIViewContentModeScaleToFill;
    CGRect tmpFrame = self.textLabel.frame;
    GLfloat fLabelWidth = tmpFrame.size.width;
    tmpFrame.origin.x = fValue + 16;
    GLfloat fOriginX = tmpFrame.origin.x;
    GLfloat fOriginY = tmpFrame.origin.y;
    GLfloat fHeight = tmpFrame.size.height;
    CGRect newFrame = CGRectMake(fOriginX, fOriginY, fLabelWidth + fImageWidth - fImageHeight + 8,  fHeight);
    self.textLabel.frame = newFrame;
    
    //[self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //[self.layer setBorderWidth:1.0f];
    /*
    CALayer* layer = [ self.textLabel layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:bottomBorder];
     */
}

@end
