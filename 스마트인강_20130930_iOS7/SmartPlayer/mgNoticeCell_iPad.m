//
//  mgNoticeCell_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgNoticeCell_iPad.h"

@implementation mgNoticeCell_iPad

@synthesize cellBgImage;
@synthesize titleText;
@synthesize idxLabel;
@synthesize gidxLabel;
@synthesize icoImage;
@synthesize cellSelectedBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 62, 704, 1)] ;
		cellBgImage.image = [UIImage imageNamed:@"cellList"];
		[self addSubview:cellBgImage];
        
        titleText = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 680, 50)] ;
		[titleText setBackgroundColor:[UIColor clearColor]];
		titleText.textColor = [UIColor blackColor];
		titleText.textAlignment = UITextAlignmentLeft;
		titleText.numberOfLines = 1;
        titleText.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
		[self addSubview:titleText];
        
        idxLabel = [[UILabel alloc] initWithFrame:CGRectMake(650, 4, 49, 21)] ;
		[idxLabel setBackgroundColor:[UIColor clearColor]];
		idxLabel.textColor = [UIColor blackColor];
		idxLabel.textAlignment = UITextAlignmentLeft;
		idxLabel.numberOfLines = 1;
        idxLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
		[self addSubview:titleText];
        idxLabel.hidden = YES;
        
        gidxLabel = [[UILabel alloc] initWithFrame:CGRectMake(650, 36, 49, 21)] ;
		[gidxLabel setBackgroundColor:[UIColor clearColor]];
		gidxLabel.textColor = [UIColor blackColor];
		gidxLabel.textAlignment = UITextAlignmentLeft;
		gidxLabel.numberOfLines = 1;
        gidxLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
		[self addSubview:gidxLabel];
        gidxLabel.hidden = YES;
        
        icoImage = [[UIImageView alloc] initWithFrame:CGRectMake(692, 27, 8, 9)] ;
		icoImage.image = [UIImage imageNamed:@"ico_click"];
		[self addSubview:icoImage];
        
        cellSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellSelectedBtn.frame = CGRectMake(0, 0, 704, 63);
        cellSelectedBtn.exclusiveTouch = YES;
        [cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"clean_nor"] forState:UIControlStateNormal];
        [cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"cellClick.png"] forState:UIControlStateHighlighted];
        [self addSubview:cellSelectedBtn];

    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
