//
//  DownViewCell.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 12..
//

#import <UIKit/UIKit.h>

@class DownViewCell;
@class mgProgressDonut;

typedef enum {
    DownViewCellStatePause,
    DownViewCellStateDownloading,
    DownViewCellStateExpired,
    DownViewCellStateFinished
} DownViewCellState;

@protocol DownViewCellDelegate <NSObject>

-(void)onAccClick:(DownViewCell *)cell at:(int)index;

@end

@interface DownViewCell : UITableViewCell

@property (assign, nonatomic) id<DownViewCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *stateImageView;
@property (assign, nonatomic) float sizeRatio;
@property (assign, nonatomic) DownViewCellState state;
@property (strong, nonatomic) IBOutlet mgProgressDonut *progressDonut;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property bool hasSession;

- (void)setSize:(unsigned long long)current total:(unsigned long long)total;
- (IBAction)onAccClick:(id)sender;
+ (id)create;
+ (NSString *)identifier;
- (void)hasSession:(bool)value;

@end
