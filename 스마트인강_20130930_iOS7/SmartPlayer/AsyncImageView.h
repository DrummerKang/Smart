//
//  AsyncImageView.h
//  Ibugslife
//
//  Created by Joseph on 10. 11. 18..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class AsyncImageView;

/**
 *@brief AsyncImageView 프로토콜 클래스
 */
@protocol AsyncImageViewDelegate <NSObject>

/**
 @brief 선택된 이미지뷰 포인터와 이미지를 파라미터로 넘겨준다.
 @param view : 이미지 뷰포인터
 @param image : 이미지 데이타
 */
-(void)selectImage:(AsyncImageView*)view image:(UIImage*)image;

/**
 @brief 이미지 다운로드후 사이즈의 변경이 종료된후 호출된다.
 */
-(void)changViewSizeDid;

/**
 @brief 좌우 터치 시 슬라이딩 스트링을 넘겨준다.
 @param str : 좌우 에니메이션 스트링
 */
-(void)Slidingdid:(NSString*)str;

@end


/**
 *@brief 웹서버에서 이미지를 동적으로 로딩 하여 이미지뷰에 뿌려준다.
 */
@interface AsyncImageView : UIView {
    
    /**
     *@brief web connect class 
     */
	NSURLConnection* connection;
    
    /**
     *@brief 웹 데이타 저장 변수 
     */
    NSMutableData* data;
	
    /**
     *@brief 터치 이벤트 를 받을 클레스의 저장 변수
     */
	id parentTarget;
    
    /**
     *@brief 터치 시작시 이벤트 함수 포인터 
     */
	SEL selecterTouchBegan;
    
    /**
     *@brief 터치 종료시 이벤트 함수 포인터
     */
	SEL selecterTourchEnd;
	
    /**
     *@brief web 연결 여부
     */
	BOOL isConnect;
    
    /**
     *@brief 이미지 파일명 
     */
	NSString* imageFileName;
	
    
    /**
     *@brief 이미지뷰의 Rect 를 부모뷰의 Rect와 동일하게 설정할건지 여부 
     */
	BOOL IsParentRect;
	
    /**
     *@brief 모래시게 뷰 
     */
	UIActivityIndicatorView* loading;
    
    /**
     *@brief 뷰의 인덱스 또는 array 의 인덱스 
     */
	int Index;
	BOOL Isreflect;
    

    /**
     *@brief 이미지 다운로드 완료시 이벤트를 받을 클레스의 저장변수
     */
    id downloadTarget;
    /**
     *@brief 이미지 다운로드 완료시 이벤트의 함수 포인터
     */
    SEL selecterDownloadcomplet;
    
    /**
     *@brief 이미지 좌우 이동 에니메션 이름
     */
    NSString* dirString;
    
    /**
     *@brief 터치 시작시 좌표
     */
	CGPoint startTouchPosition;
    
    
    /**
     *@brief 대용량 파일 다운로드시 의 파일 포인터
     */    
    NSFileHandle *writeFile;
    
	
}
@property (nonatomic, assign) UIImage* _tempImage;
/**
 *@brief web 연결 여부
 */
@property (nonatomic) BOOL isConnect;

/**
 *@brief 뷰의 인덱스 또는 array 의 인덱스 
 */
@property (nonatomic) int Index;
@property (nonatomic) BOOL Isreflect;

/**
 *@brief 이미지 정보 Dictionary(json 형태로 저장되어짐)
 */
@property (nonatomic,retain)NSMutableDictionary* imageDataDic;

/**
 *@brief 이미지가 없을때 보여줄 이미지의 이름
 */
@property (nonatomic,retain) NSString* notImagePath;

/**
 *@brief 사용자 델리게이트
 */
@property (nonatomic,assign) id<AsyncImageViewDelegate>delegate;

/**
 *@brief 케쉬 이미지 파일경로
 */
@property (nonatomic,retain) NSString* ImagePath ;

/**
 *@brief 원본 이미지 사이즈로 보여줄지 여부
 */
@property (nonatomic)BOOL IsViewSizeFormimageData;


/**
 *@brief 이미지를 크랍하여 보여줄지 여부
 */
@property(nonatomic) BOOL IsCropImage;

/**
 *@brief 이미지를 크랍하여 보여줄지 여부
 */
@property(nonatomic) BOOL IsThumbNainSave;

/**
 *@brief 이미지 다운로드후 썸네일 크기로 설정하여 보여줄지 여부
 */
@property(nonatomic)BOOL IsFileCash;

/**
 *@brief 이미지 URL 정보로 파일을 로드 한다.
 *@param url: image url
 */

- (void)loadImageFromURL:(NSURL*)url ;
-(void)SetDefaultImage;
/**
 *@brief 터치 시 이벤트를 받을 클래스 및 함수 포인터를 설정한다.
 *@param target: 이벤트를 받을 클래스
 *@param touchSelBegan : 터치 시작시 함수 포인터
 *@parma touchSelEnd: 터치 종료시 함수 포인터
 */
-(void)SetTouchSelecter:(id)target selecterBegan:(SEL)touchSelBegan selecterEnd:(SEL)touchSelEnd;
/**
 *@brief 이미지를 설정한다.
 *@param Image: 이미지 데이타
 */
-(void)SetImage:(UIImage*)Image;
/**
 *@brief 이미지뷰의 Rect 를 부모뷰의 Rect와 동일하게 설정할건지 여부 
 *@param bMode: Y/N
 */
-(void)SetImageViewParentRect:(BOOL)bMode;
/**
 *@brief 화면을 갱신한다.
 */
-(void)RefreshImageView;
/**
 *@brief 이미지뷰를 반환한다.
 *@return 이미지뷰포인터 반환
 */
-(UIImageView*)GetImageView;
//-(void)GetImageURL:(NSString*)Exid;
//-(void)GetImageURLEx:(NSString*)key dataDic:(NSMutableDictionary*)dic;

/**
 *@brief 이미지 다운로드 완료시 이벤트를 받을 클레스 와 함수포인터를 설정한다.
 *@param target: 이벤트 받을 클레스 포인터
 *@param select: 완료시 호출할 함수 포인터  
 */
-(void)setdownloadCompletSelect:(id)target select:(SEL)select;
//-(void)setFrame:(CGRect)frame;
/**
 *@brief 좌우 에니메이션을 실행한다.
 *@param direction: 좌우 에니메이션 스트링
 */
- (CATransition *) getAnimation:(NSString *) direction;
/**
 *@brief 디폴트로 보여줄 이미지 파일명
 */
-(void)SetDefaultImage:(NSString*)imagePath;

/**
 *@brief 이미지를 화면 비율에 맞게 설정한다.
 *@param Image: 이미지 데이타
 */
-(void)SetResizeImae:(UIImage*)Image;;

/**
 *@brief dataDic에 저장된 케쉬파일의 경로가 들어 있다면 이것으로 보여주고 없다면 웹에서 로딩
 *@param url: 이미지 url          
 *@param dataDic: 이미지 data Dictionary
 */
- (void)loadImageFromURL:(NSURL*)url dataDic:(NSMutableDictionary*)dataDic;

/**
 *@brief 파일케쉬를 이용하여 파일 다운로드 한다.
 *@param url: 이미지 url          
 */
- (void)loadImageFileCashFromURL:(NSURL*)url;
@end
