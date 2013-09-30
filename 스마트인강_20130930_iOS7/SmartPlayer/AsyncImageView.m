//
//  AsyncImageView.m
//  Ibugslife
//
//  Created by edl on 10. 11. 18..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>


#define ASYNC_IMAGE_VIEW		0x1000
#define IMAGE_URL_KEY           @"image_url"

#define IMAGE_FILE_PATH_KEY           @"image_filePath"

#define HORIZ_SWIPE_DRAG_MIN 12 
#define VERT_SWIPE_DRAG_MAX 4 

@implementation AsyncImageView

@synthesize isConnect;
@synthesize  Index;
@synthesize Isreflect;
@synthesize imageDataDic;
@synthesize notImagePath;
@synthesize delegate;
@synthesize ImagePath;
@synthesize IsViewSizeFormimageData;
@synthesize IsCropImage;
@synthesize IsThumbNainSave;
@synthesize IsFileCash;
@synthesize _tempImage;

-(id)init{
    self= [super init];
    if(self){
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if(self){
        
    }
    
    return  self;
}

// MD5 해쉬
-(NSString*) MakeMD5:(NSString*)srcStr{
	if(srcStr == nil || [srcStr isEqualToString:@""])
		return @"";
	const char *cStr = [srcStr UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
			result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
}

/**
 *@brief 케쉬파일 유무를 반환한다.
 *@param ImageName: 검색할 파일명
 *@return Y/N
 */
-(BOOL)IsFindImageFile:(NSString*)ImageName{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
														 NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:ImageName];
	if( [fileManager fileExistsAtPath:fullPath] )
	{
		return TRUE;
    }
	return FALSE;	
}

/**
 *@brief 케쉬파일 저장경로를 생성한다.
 *@param ImageName: 저장할 파일명
 *@return 캐쉬파일 경로
 */
-(NSString*)MakeImageFilePath:(NSString*)ImageName
{
	//NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
														 NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:ImageName];
   
	return fullPath;
}

/**
 *@brief 썸네일 이미지를 반환한다.
 *@param image : 원본 이미지
 *@param bOnlyCrop : 리사이즈없이 CROP만 할지 여부,
 *@param size : 리사이즈할 정사각형 한변의 길이
 *@return CROP 및 리사이즈된 이미지 
 */
- (UIImage*) makeThumbnailImage:(UIImage*)image onlyCrop:(BOOL)bOnlyCrop Size:(float)size
{
    CGRect rcCrop;
    /*
    if (image.size.width == image.size.height)
    {
        rcCrop = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    else if (image.size.width > image.size.height) 
    {
        int xGap = (image.size.width - image.size.height)/2;
        rcCrop = CGRectMake(xGap, 0.0, image.size.height, image.size.height);
    }
    else 
    {
        int yGap = (image.size.height - image.size.width)/2;
        rcCrop = CGRectMake(0.0, yGap, image.size.width, image.size.width);
    }
     */
    
    if(size < image.size.width)
    {
        float with = image.size.width / size * image.size.width;
        
        float min = image.size.width - with;
        float height = image.size.height - (image.size.height/image.size.width * min);
      
        rcCrop = CGRectMake(0, 0, with, height);
    }
    else
    {
        return image;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rcCrop);
    UIImage* cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    if (bOnlyCrop) 
        return cropImage;
    
    NSData* dataCrop = UIImagePNGRepresentation(cropImage);
    UIImage* imgResize = [[UIImage alloc] initWithData:dataCrop];
    
    UIGraphicsBeginImageContext(CGSizeMake(size,size));
    [imgResize drawInRect:CGRectMake(0.0f, 0.0f, size, size)];
    UIImage* imgThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgThumb;
}

/**
 *@brief 이미지를 리사이즈 하여 반환한다.
 *@param image : 원본 이미지
 *@param thumbRect : 리사이즈 할 Rect
 *@return 리사이즈된 이미지 
 */
-(UIImage*)resizedImage1:(UIImage*)inImage  inRect:(CGRect)thumbRect {
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[inImage drawInRect:thumbRect];
    
	return UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark 이미지 사용자 폴더에 저장
/**
 *@brief 이미지 사용자 폴더에 저장
 *@param image : 원본 이미지
 *@param name : 저장할 이미지명(이미지 URL)
 *@return 케쉬 파일 경로 
 */
- (NSString*)saveImage:(UIImage *)image withName:(NSString *)name {
    //save image
	//NSLog(@"name = %@",name);
    UIImage* tempImage;
    if(IsThumbNainSave)
    {
        CGRect thumbRt = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        tempImage = [self resizedImage1:image inRect:thumbRt];
    }
    else
    {
        tempImage = image;
    }
    
    NSData *dataImage = UIImagePNGRepresentation(tempImage);//, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
														 NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
	
    NSError *error = nil;
    if( [fileManager fileExistsAtPath:fullPath] ){
        if( ! [fileManager removeItemAtPath:fullPath error:&error] ) {
			//NSLog(@"Failed deleting background image file %@", error);
			// the write below should fail. Add your own flag and check below.
			return nil;
        }
    }
    [dataImage writeToFile:fullPath atomically:YES];
    self.ImagePath = fullPath;
    
    
    
	return fullPath;
}

/**
 *@brief dataDic에 저장된 케쉬파일의 경로가 들어 있다면 이것으로 보여주고 없다면 웹에서 로딩
 *@param url: 이미지 url          
 *@param dataDic: 이미지 data Dictionary
 */
- (void)loadImageFromURL:(NSURL*)url {
	
    if(isConnect){
        [connection cancel];
        connection = nil;
        data = nil;
        
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
    }
    
	////NSLog(@"url absoluteString = %@",[url absoluteString]);
	imageFileName = [[NSString alloc] initWithFormat:@"%@",[self MakeMD5:[url absoluteString]]];
    ////NSLog(@"imageFileName = %@",imageFileName);
    if(self.imageDataDic){
        [self.imageDataDic setValue:imageFileName forKey:IMAGE_URL_KEY];
    }

    
	if([self IsFindImageFile:imageFileName]){
		self.ImagePath = [self MakeImageFilePath:imageFileName];
		UIImage* fileImae = [UIImage imageWithContentsOfFile:self.ImagePath];

        if(self.IsViewSizeFormimageData){
            [self SetResizeImae:fileImae];
        
        }else
            [self SetImage:fileImae];
		return;
	}
    
   		
	isConnect = TRUE;
	if (connection!=nil) { 
        
    } //in case we are downloading a 2nd image
	
    /*
	if(loading)
	{
		[loading startAnimating];
		[self bringSubviewToFront:loading];		
	}
	else
	{
		loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];	
		loading.center = CGPointMake(self.frame.size.width/2.0 , self.frame.size.height/2.0);	
		loading.hidesWhenStopped = YES;
		[self addSubview:loading];
		[loading startAnimating];
	}
     */
    
    IsFileCash = FALSE;
   	
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
}

/**
 *@brief 파일케쉬를 이용하여 파일 다운로드 한다.
 *@param url: 이미지 url          
 */
- (void)loadImageFileCashFromURL:(NSURL*)url {
	
    if(isConnect){
        [connection cancel];
        connection = nil;
        data = nil;
        
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
    }
    
	//NSLog(@"url absoluteString = %@",[url absoluteString]);
	imageFileName = [[NSString alloc] initWithFormat:@"%@.png",[self MakeMD5:[url absoluteString]]];
    //NSLog(@"imageFileName = %@",imageFileName);

    if(self.imageDataDic){
        [self.imageDataDic setValue:imageFileName forKey:IMAGE_URL_KEY];
    }
        
	if([self IsFindImageFile:imageFileName]){
		self.ImagePath = [self MakeImageFilePath:imageFileName];
		UIImage* fileImae = [UIImage imageWithContentsOfFile:self.ImagePath];
        if(self.IsViewSizeFormimageData){
            [self SetResizeImae:fileImae];
        
        }else
            [self SetImage:fileImae];
		return;
	}
    
    self.ImagePath = [self MakeImageFilePath:imageFileName];
    //NSLog(@"self.ImagePath = %@",self.ImagePath);
	isConnect = TRUE;
	
    if (connection!=nil){
    
    } //in case we are downloading a 2nd image

    [[NSFileManager defaultManager] createFileAtPath:self.ImagePath contents: nil attributes:nil];
    writeFile =  [NSFileHandle fileHandleForWritingAtPath:self.ImagePath];
  
    IsFileCash = YES;
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}

/**
 *@brief dataDic에 저장된 케쉬파일의 경로가 들어 있다면 이것으로 보여주고 없다면 웹에서 로딩
 *@param url: 이미지 url          
 *@param dataDic: 이미지 data Dictionary
 */
- (void)loadImageFromURL:(NSURL*)url dataDic:(NSMutableDictionary*)dataDic {
	
    if(isConnect){
        [connection cancel];
        connection = nil;

        data = nil;
    }
    
    if(dataDic){
        NSString* imageFilePath = [dataDic objectForKey:IMAGE_FILE_PATH_KEY];
        
        if(imageFilePath){
            self.ImagePath = [self MakeImageFilePath:imageFilePath];
            UIImage* fileImae = [UIImage imageWithContentsOfFile:self.ImagePath];
            
            if(fileImae){
                if(self.IsViewSizeFormimageData){
                    [self SetResizeImae:fileImae];
                
                }else
                    [self SetImage:fileImae];
                return;
            }
        }
    }
    
	//NSLog(@"url absoluteString = %@",[url absoluteString]);
	imageFileName = [[NSString alloc] initWithFormat:@"%@.png",[self MakeMD5:[url absoluteString]]];
    //NSLog(@"imageFileName = %@",imageFileName);
    if(dataDic){
        [dataDic setValue:imageFileName forKey:IMAGE_FILE_PATH_KEY];
    }
        
	if([self IsFindImageFile:imageFileName]){
		self.ImagePath = [self MakeImageFilePath:imageFileName];
		UIImage* fileImae = [UIImage imageWithContentsOfFile:self.ImagePath];
        
        if(self.IsViewSizeFormimageData){
            [self SetResizeImae:fileImae];
        
        }else
            [self SetImage:fileImae];
		return;
	}
    
    
	isConnect = TRUE;
	if (connection!=nil){
    
    } //in case we are downloading a 2nd image
	
    if (data!=nil){
    
    }
	
    /*
     if(loading)
     {
     [loading startAnimating];
     [self bringSubviewToFront:loading];		
     }
     else
     {
     loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];	
     loading.center = CGPointMake(self.frame.size.width/2.0 , self.frame.size.height/2.0);	
     loading.hidesWhenStopped = YES;
     [self addSubview:loading];
     [loading startAnimating];
     }
     */
    
	 IsFileCash = FALSE;
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse{
    NSArray *cookies;
    NSMutableDictionary *responseHeaderFields;
    
    // 받은 header들을 dictionary형태로 받고
    responseHeaderFields = [(NSHTTPURLResponse *)aResponse allHeaderFields];
    
    if(responseHeaderFields != nil){
        // responseHeaderFields에 포함되어 있는 항목들 출력
        for(NSString *key in responseHeaderFields){
            ////NSLog(@"Header: %@ = %@", key, [responseHeaderFields objectForKey:key]);
        }
        
        // cookies에 포함되어 있는 항목들 출력
        cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:responseHeaderFields forURL:[aResponse URL]];
        
        if(cookies != nil){
            for(NSHTTPCookie *a in cookies){
                //NSLog(@"Cookie: %@ = %@", [a name], [a value]);
            }
        }
    }
}

/**
 *@brief Sent as a connection loads data incrementally.
 */
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    
    if(IsFileCash){
        [writeFile seekToEndOfFile];
        [writeFile writeData:incrementalData];
        //[writeFile seekToFileOffset:incrementalData.length];
    
    }else{
        
        if (data==nil) { 
            data = [[NSMutableData alloc] initWithCapacity:2048]; 
        }
        
        [data appendData:incrementalData];
    }    
}

/**
 *@brief Sent when a connection fails to load its request successfully.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if(IsFileCash){
        [writeFile closeFile];

        writeFile = nil;
        [[NSFileManager defaultManager] removeItemAtPath:self.ImagePath error:NULL];
    }    

    self.Index = -1;
    
    if(loading)
		[loading stopAnimating];
    
	data=nil;
	isConnect = FALSE;
    
    if(self.notImagePath){
        if ([[self subviews] count]>0) {
            //then this must be another image, the old one is still in subviews
            [[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
        }
        
        [self SetImage:[UIImage imageNamed:self.notImagePath]];
    }
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

/**
 *@breif Sent when a connection has finished loading successfully.
 */
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
    
	if(loading)
		[loading stopAnimating];
    
	connection=nil;
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
       
    if(IsFileCash){
        [writeFile closeFile];

        writeFile = nil;
        UIImage* imageTemp = [UIImage imageWithContentsOfFile:self.ImagePath];

        if(imageTemp){
            if(self.IsViewSizeFormimageData){
                [self SetResizeImae:imageTemp];
                
                if([self superview]){
                    if([self.delegate respondsToSelector:@selector(changViewSizeDid)])
                        [self.delegate changViewSizeDid];
                }
                
            }else
                [self SetImage:imageTemp];
        
        }else{
            self.Index = -1;
            if(self.notImagePath)
                [self SetImage:[UIImage imageNamed:self.notImagePath]];
        }
        
    }else{
        UIImage* imageTemp = [UIImage imageWithData:data];
        /*
        //make an image view for the image
        if(imageTemp){
            [self saveImage:imageTemp withName:imageFileName];
            if(self.IsViewSizeFormimageData){
                [self SetResizeImae:imageTemp];
                
                if([self superview]){
                    if([self.delegate respondsToSelector:@selector(changViewSizeDid)])
                        [self.delegate changViewSizeDid];
                }
                
            }else
                [self SetImage:imageTemp];
        
        }else{
            self.Index = -1;
            if(self.notImagePath)
                [self SetImage:[UIImage imageNamed:self.notImagePath]];
        }
         */
        [self SetImage:imageTemp];
    }
   
    if(data){
        data=nil;
    }
	
	isConnect = FALSE;
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

/**
 *@brief 이미지를 화면 비율에 맞게 설정한다.
 *@param Image: 이미지 데이타
 */
-(void)SetResizeImae:(UIImage*)Image;{

    if ([[self subviews] count]>0) {
        //then this must be another image, the old one is still in subviews
        //[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
        
        for(UIView* view in self.subviews){
            [view removeFromSuperview];
        }        
    }
    
    //make an image view for the image
    UIImageView* imageView = [[UIImageView alloc] initWithImage:Image];
    imageView.userInteractionEnabled = YES;
    imageView.tag = ASYNC_IMAGE_VIEW;
    
    CGRect mainRt = self.frame;
    
    if(mainRt.size.width < Image.size.width){// 부모뷰의 폭이 이미지뷰의 폭보다 작을때
        float min = Image.size.width - mainRt.size.width;
        float height = Image.size.height - (Image.size.height/Image.size.width * min);
        float width = mainRt.size.width;
        CGRect imageViewRt = CGRectMake(0, 0, width, height);
        imageView.frame = imageViewRt;
        mainRt.size.width = width;
        mainRt.size.height = height;
        self.frame = mainRt;              
        
        [self addSubview:imageView];                   
    
    }else{ // 이미지 가 부모뷰 폭보다 작거나 같을때
        /*
        mainRt.size.height = Image.size.height;
        self.frame = mainRt;
        [self addSubview:imageView];
        imageView.frame = CGRectMake(mainRt.size.width/2.0f - Image.size.width/2.0f, 0, Image.size.width, Image.size.height);
         */
        
        float heigth = (Image.size.height / Image.size.width) * mainRt.size.width;
        mainRt.size.height = heigth;
        self.frame = mainRt;
        [self addSubview:imageView];
        imageView.frame = CGRectMake(0, 0, mainRt.size.width, mainRt.size.height);
    }
    
        /*
         if(Image.size.height > Image.size.width) // 이미지뷰 높이 넓이 보다 클때
         {
         if(mainRt.size.width < Image.size.width)// 부모뷰의 폭이 이미지뷰의 폭보다 작을때
         {
         float min = Image.size.width - mainRt.size.width;
         float height = Image.size.height - (Image.size.height/Image.size.width * min);
         float width = mainRt.size.width;
         CGRect imageViewRt = CGRectMake(0, 0, width, height);
         imageView.frame = imageViewRt;
         mainRt.size.width = width;
         mainRt.size.height = height;
         self.frame = mainRt;              
         
         [self addSubview:imageView];                   
         }
         else // 이미지 가 부모뷰 폭보다 작거나 같을때
         {
         
         mainRt.size.height = Image.size.height;
         self.frame = mainRt;
         [self addSubview:imageView];
         imageView.frame = CGRectMake(0, 0, Image.size.width, Image.size.height);
         }
         }
         else
         {
         
         }
         */
}

/**
 *@brief just in case you want to get the image directly, here it is in subviews
 */
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

/**
 *@brief 디폴트로 보여줄 이미지 파일명
 */
-(void)SetDefaultImage{
    if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		//[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
        
		for(UIView* view in self.subviews){
			[view removeFromSuperview];
		}		
	}
    
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_profile_photo_box2.png"]];
	
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	imageView.tag = ASYNC_IMAGE_VIEW;
	
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
}

/**
 *@brief 디폴트로 보여줄 이미지 파일명
 */
-(void)SetDefaultImage:(NSString*)imagePath{
    if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		//[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
        
		for(UIView* view in self.subviews){
			[view removeFromSuperview];
		}
	}
    
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
	
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	imageView.tag = ASYNC_IMAGE_VIEW;
	
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
}

/**
 *@brief 화면을 갱신한다.
 */
-(void)RefreshImageView{
	UIImageView* imageView = (UIImageView*)[self viewWithTag:ASYNC_IMAGE_VIEW];
	
    if(imageView){
	
	//	[imageView setNeedsLayout];
	//	[self setNeedsLayout];
		
		if(IsParentRect)	{
			CGRect rt = CGRectMake(0, 0,self.frame.size.width,self.frame.size.height);
			[imageView setFrame:rt];
			
		}else{
			//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
			
			imageView.frame = self.bounds;
			[imageView setNeedsLayout];
			[self setNeedsLayout];
		}	
	}	
}

/**
 *@brief 이미지르르 크랍 하여 반환
 *@param imageToCrop : 크랍할 이미지
 *@param rect : 이미지에서 크랍영역
 *@reutn 크랍이미지
 */
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect{
	CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	
	CGImageRelease(imageRef);
	
	return cropped;
}

/**
 *@brief 이미지를 설정한다.
 *@param Image: 이미지 데이타
 */
-(void)SetImage:(UIImage*)Image{
    //UIImage* tempImage ;
    if(downloadTarget){
        if([downloadTarget respondsToSelector:selecterDownloadcomplet])
            [downloadTarget performSelector:selecterDownloadcomplet];
    }
       
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		//[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
				
		for(UIView* view in self.subviews){
			[view removeFromSuperview];
		}		
	}
    
    if(self.IsCropImage){
        if(Image.size.width == Image.size.height){
            _tempImage = Image;
        
        }else if(Image.size.width > Image.size.height){
            float posX = Image.size.width/2.0f - Image.size.height/2.0f;
            float posY = 0;
            CGRect cropRt = CGRectMake(posX, posY, Image.size.height, Image.size.height);
            _tempImage = [self imageByCropping:Image toRect:cropRt];
            
        }else{
            float posX = 0;
            float posY = Image.size.height/2.0f - Image.size.width/2.0f;
            CGRect cropRt = CGRectMake(posX, posY, Image.size.width, Image.size.width);
            _tempImage = [self imageByCropping:Image toRect:cropRt];
        }        
    
    }else{
        _tempImage = Image;
    }
	
	//make an image view for the image
	UIImageView* imageView = [[UIImageView alloc] initWithImage:_tempImage];
	imageView.userInteractionEnabled = YES;
	imageView.tag = ASYNC_IMAGE_VIEW;
    
	if(IsParentRect)	{
		CGRect rt = CGRectMake(0, 0,self.frame.size.width,self.frame.size.height);
		[imageView setFrame:rt];
		[self addSubview:imageView];
	
    }else{
    
        {
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight );
            [self addSubview:imageView];
            imageView.frame = self.bounds;
            [imageView setNeedsLayout];
            [self setNeedsLayout];
        }		
	}	
		
	if(Isreflect){
		
	}
}

/**
 *@brief 터치 시 이벤트를 받을 클래스 및 함수 포인터를 설정한다.
 *@param target: 이벤트를 받을 클래스
 *@param touchSelBegan : 터치 시작시 함수 포인터
 *@parma touchSelEnd: 터치 종료시 함수 포인터
 */
-(void)SetTouchSelecter:(id)target selecterBegan:(SEL)touchSelBegan selecterEnd:(SEL)touchSelEnd{
	parentTarget = target;
	selecterTouchBegan = touchSelBegan;	
	selecterTourchEnd = touchSelEnd;
	self.userInteractionEnabled = YES;
}

/**
 *@brief Tells the receiver when one or more fingers touch down in a view or window.
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject]; 
	startTouchPosition = [touch locationInView:self]; 
	dirString = NULL;
    
	if(parentTarget){
		if([parentTarget respondsToSelector:selecterTouchBegan]){
			[parentTarget performSelector:selecterTouchBegan withObject:(id)Index];
        }
        
    }else {
		[[self superview] touchesBegan:touches withEvent:event];
	}
}

/**
 *@brief Tells the receiver when one or more fingers associated with an event move within a view or window.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { 
	UITouch *touch = touches.anyObject; 
	CGPoint currentTouchPosition = [touch locationInView:self]; 
	
	if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= 
		HORIZ_SWIPE_DRAG_MIN/* && 
							 fabsf(startTouchPosition.y - currentTouchPosition.y) <= 
							 VERT_SWIPE_DRAG_MAX*/){ 
		// Horizontal Swipe
		if (startTouchPosition.x < currentTouchPosition.x) {
			dirString = kCATransitionFromLeft;
		
        }else 
			dirString = kCATransitionFromRight;
	} 
}

/**
 *@brief Tells the receiver when one or more fingers are raised from a view or window.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isConnect)
        return;
    UITouch *touch = [touches anyObject]; 
	CGPoint endPt = [touch locationInView:self]; 
    CGRect endPtRect =  CGRectMake(endPt.x -10, endPt.y - 10, 20,20);
    
	if(parentTarget){
		if([parentTarget respondsToSelector:selecterTourchEnd]){
			[parentTarget performSelector:selecterTourchEnd withObject:(id)Index];
        }
        
    }else{
        if([self superview]){
            if(self.delegate){
                if(CGRectContainsPoint(endPtRect, startTouchPosition)){
                    //NSLog(@"self.ImagePath = %@",self.ImagePath);
                    if([self.delegate respondsToSelector:@selector(selectImage:image:)])
                        [self.delegate selectImage:self image:[UIImage imageWithContentsOfFile:self.ImagePath]];
                
                }else{
                    if([self.delegate respondsToSelector:@selector(Slidingdid:)])
                        [delegate Slidingdid:dirString];
                }                
            }     
        }
           
		[[self superview] touchesEnded:touches withEvent:event];
	}
}
 
/**
 *@brief 이미지뷰의 Rect 를 부모뷰의 Rect와 동일하게 설정할건지 여부 
 *@param bMode: Y/N
 */
-(void)SetImageViewParentRect:(BOOL)bMode{
	IsParentRect = bMode;
}

/**
 *@brief 이미지뷰를 반환한다.
 *@return 이미지뷰포인터 반환
 */
-(UIImageView*)GetImageView{
	UIImageView* imageView = (UIImageView*)[self viewWithTag:ASYNC_IMAGE_VIEW];
	return imageView;
}

/**
 *@brief 이미지 다운로드 완료시 이벤트를 받을 클레스 와 함수포인터를 설정한다.
 *@param target: 이벤트 받을 클레스 포인터
 *@param select: 완료시 호출할 함수 포인터  
 */
-(void)setdownloadCompletSelect:(id)target select:(SEL)select{
    downloadTarget = target;
    selecterDownloadcomplet = select;
}

/**
 *@brief 좌우 에니메이션을 실행한다.
 *@param direction: 좌우 에니메이션 스트링
 */
- (CATransition *) getAnimation:(NSString *) direction{
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	// [animation setType:@"oglFlip"]; 
	[animation setType:kCATransitionPush];
	[animation setSubtype:direction];
	[animation setDuration:0.5];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}

/*
-(void)setFrame:(CGRect)frame
{
	[self setFrame:frame];
	
	UIImageView* imageView = (UIImageView*)[self viewWithTag:ASYNC_IMAGE_VIEW];
	if(imageView)
	{
		if(IsParentRect)	
		{
			CGRect rt = CGRectMake(0, 0,self.frame.size.width,self.frame.size.height);
			[imageView setFrame:rt];
			
		}
		else
		{
			//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );			
			imageView.frame = self.bounds;
			[imageView setNeedsLayout];
			[self setNeedsLayout];
		}		
	
	}	
}
 */

- (void)dealloc {
    
    if(connection)
    {
        [connection cancel]; //in case the URL is still downloading
        [connection release];
        connection = nil;
        [data release]; 
        data = nil;
    }
    
	if(loading)
	{
		[loading release];
		loading = nil;
	}
    if(ImagePath)
        [ImagePath release];
    if(imageDataDic)
        [imageDataDic release];
    if(notImagePath)
        [notImagePath release];
    
    [super dealloc];
}

@end
