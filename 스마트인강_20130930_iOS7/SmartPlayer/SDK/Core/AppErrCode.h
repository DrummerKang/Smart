//
//  AppErrCode.h
//  eduManager
//
//  Created by CDNetworks on 12. 7. 13..
//

#ifndef eduManager_AppErrCode_h
#define eduManager_AppErrCode_h

#define APP_FILE_CREATE_FAIL -10000
//파일 생성 오류
#define APP_DIR_CREATE_FAIL -10001
//디렉터리 생성 오류
#define APP_FILE_HANDLE_FAIL -10002
//파일핸들 오류
#define APP_NOT_ALLOW_3G_DOWNLOAD -10003
//3G다운로드 허용안됨
#define APP_DOWNLOAD_CONNECTION_ERROR -10004
//다운로드중 에러
#define APP_DOWNLOAD_CONNECTION_SERVER_ERROR -10005
//서버에러
#define APP_CONTENT_EXPIRED -10006
//컨텐츠 만료
#define APP_NO_FREE_SIZE -10007
//용량이 부족하여 컨텐츠를 받을수 없음
#define APP_CONTENT_UNKNOWN -10008
//컨텐츠 정보를 알 수없습니다.

#define APP_PLAYER_NOT_FOUND 404
//404 파일을 찾을 수 없습니다.
#define APP_PLAYER_AUTHENTICATION_FAILED 403
//mesg  = @"미디어 인증에 실패하였습니다. 재시도 하세요.
#define APP_PLAYER_CONNECTION_FAIL 503
//서버 연결에 실패하였습니다. 잠시 후 재시도 하세요.
#define CONTENT_UPDATE_TEXT 1000
//업데이트 내역이 있습니다.
#define ERR_DUPLICATION 1001
//중복로그인 정책에 의한 로그아웃
#define ERR_CONTENT_MODIFY 1002
//다운 받는중 컨텐츠가 바뀐경우
#define APP_DEVICE_LIMIT 1003
//디바이스 체크 리미트

#endif
