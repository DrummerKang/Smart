//
//  DownViewCell.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 12..
//

#import "DownViewCell.h"
#import "mgProgressDonut.h"

static NSString *identifier = @"downviewCell";

@implementation DownViewCell
{
}

@synthesize subTitleLabel;
@synthesize stateImageView;
@synthesize sizeRatio;
@synthesize delegate;
@synthesize state;
@synthesize progressDonut;
@synthesize delBtn;

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"DownViewCell" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    DownViewCell *cell = [arr objectAtIndex:0];
    
    [cell setSizeRatio:0];
    cell.state = DownViewCellStatePause;
    
    cell.hasSession = false;
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

- (NSString *)toSizeFormat:(unsigned long long)size{
    NSArray *arrSize = [[NSArray alloc] initWithObjects:@"Byte",@"KB",@"MB",@"GB", nil];
    
    int idx = 0;
    double val = size;
    while (val>1024) {
        val /= 1024;
        idx++;
    }
    
    NSString *ret = [NSString stringWithFormat:@"%.2f%@",round(val/0.01)*0.01,[arrSize objectAtIndex:idx]];
    [arrSize release];
    
    return ret;
}

- (void)setSize:(unsigned long long)current total:(unsigned long long)total{
    sizeRatio = (double)current/total;
    if (total <= 0) {
        sizeRatio = 0;
    }else {
        if (sizeRatio > 1) {
            sizeRatio = 1;
        
        }else if(sizeRatio <= 0){
            sizeRatio = 0;
        }
    }
    
    [progressDonut setProgress:sizeRatio];
}

- (void)setState:(DownViewCellState)_state{    
    self.stateImageView.tag = _state;
    self.delBtn.tag = _state;
    
    switch (_state) {
        case DownViewCellStatePause:
            [self.stateImageView setImage:[UIImage imageNamed:@"btn_down_.png"] forState:UIControlStateNormal];
            
            self.stateImageView.enabled = self.hasSession;
            self.delBtn.hidden = !self.hasSession;

            self.progressDonut.hidden = YES;
            break;
        case DownViewCellStateExpired:
            break;
        case DownViewCellStateDownloading:
            [self.stateImageView setImage:[UIImage imageNamed:@"btn_down_stop.png"] forState:UIControlStateNormal];
            self.delBtn.hidden = YES;
            self.progressDonut.hidden = NO;
            break;
        case DownViewCellStateFinished:
            [self.stateImageView setImage:[UIImage imageNamed:@"btn_check_s.png"] forState:UIControlStateNormal];
            [self.stateImageView setImage:[UIImage imageNamed:@"btn_check_s.png"] forState:UIControlStateHighlighted];
            break;
    }
}

- (DownViewCellState)state{
    return self.stateImageView.tag;
    return self.delBtn.tag;
}

- (IBAction)onAccClick:(id)sender {
    if (delegate) {
        [delegate onAccClick:self at:[self tag]];
    }
}

- (void)hasSession:(bool)value
{
    if (value == true && self.state == DownViewCellStatePause) {
        self.delBtn.hidden = NO;
    }
    self.stateImageView.enabled = value;
    self.hasSession = value;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [subTitleLabel release];
    [stateImageView release];
    [super dealloc];
}

@end
