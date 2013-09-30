//
//  DownViewController.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 11..
//

#import <UIKit/UIKit.h>
#import "DownViewCell.h"
#import "AquaAlertView.h"
#import "CDNDownloadHeader.h"
#import "CDNDownloadContext.h"
#import "mgUIControllerCommon.h"
#import "mgTableView.h"
#import "HTTPNetworkManager.h"

@interface DownViewController : mgUIControllerCommon<ASIHTTPRequestDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, DownViewCellDelegate, UITableViewDataSource, UITableViewDelegate, mgTableViewDelegate, UIAlertViewDelegate>{
    int currentDownloadIndex;
    unsigned long long downBytes;
    BOOL downloadReady;
    BOOL afterDelete;
    int nRetry;
    
    ASIHTTPRequest *downRequest;
    
    NSString *cidNum;
    
    NSInteger delNumber;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *downNavigationBar;
@property (retain, nonatomic) DownViewCell *downloadCell;
@property (retain, nonatomic) CDNDownloadHeader *downloadHeader;
@property (retain, nonatomic) CDNDownloadContext *downloadContext;
@property (retain, nonatomic) CDNSession *downloadSession;
@property (retain, nonatomic) NSURLConnection *downloadConnection;
@property (retain, nonatomic) NSString *contentPath;
@property (retain, nonatomic) NSFileHandle *fileHandle;
@property (retain, nonatomic) NSMutableArray *arrContents;

//@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet mgTableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) IBOutlet UILabel *countNum;

@property (strong, nonatomic) IBOutlet UIView *completeView;

- (IBAction)completeBtn:(id)sender;
- (IBAction)downloadListBtn:(id)sender;

- (IBAction)delBtn:(id)sender;

- (void)addItem:(NSDictionary *)dicData param:(NSString *)param;
- (int)addObjects:(NSArray *)arr;
- (void)downloadCancel;
- (IBAction)backBtn:(id)sender;

@end
