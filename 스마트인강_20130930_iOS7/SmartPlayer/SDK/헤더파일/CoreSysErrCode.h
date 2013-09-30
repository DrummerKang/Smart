//
//  CoreSysErrCode.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 27..
//

#ifndef AquaPlayer_CoreSysErrCode_h
#define AquaPlayer_CoreSysErrCode_h

#define CDDR_DL_RESULT_SUCCESS 0
//-함수의 성공적인 수행을 의미한다.
#define CDDR_DL_RESULT_FAIL -1
//-함수의 일반적인 실패를 의미한다.
#define CDDR_DL_INVALID_PARAMETER -101
//-함수로 전달되는 파리 미터 정보가 정확하지 않음을 의미한다.
#define CDDR_DL_OUT_OF_MEMORY -201
//-함수 내부의 작업에서 메모리 할당이 실패하였음을 의미한다.
#define CDDR_DL_BUF_IS_TOO_SHORT -202
//-함수의 파라 미터로 전달된 버퍼의 사이즈가 작음을 의미한다.
#define CDDR_DL_CONTENT_BASE_PATH_INCORRECT -301
//-함수의 내부에서 사용되는 Base Path가 존재하지 않는다는 것을 의미한다.
#define CDDR_DL_CONTENT_PATH_INCORRECT -302
//-함수 내부에서 사용되는 파일의 경로가 부적절하다는 것을 의미한다.
#define CDDR_DL_FILE_NOT_EXIST -303
//-함수 내부의 파일 오픈에서 파일이 존재하지 않다는 것을 의미한다.
#define CDDR_DL_FILE_SIZE_TOO_SHORT -304
//-함수 내부에서 오픈된 파일의 사이즈가 DRM이 적용된 파일이라는 것을 판단하기에는 너무 적은 사이즈라는 것을 의미한다.
#define CDDR_DL_FILE_READ_FAIL -305
//-함수 내부의 파일 읽기 작업이 실패하였다.
#define CDDR_DL_FILE_WRITE_FAIL -306
//-함수 내부의 파일 쓰기 작업이 실패 하였다.
#define CDDR_DL_FILE_OPEN_FAIL -307
//-함수 내부의 파일 오픈이 실패하였다.
#define CDDR_DL_FILENAME_INVALID -308
//-함수 내부에서 파일을 오픈하기 위한 파일명이 부적절하다/
#define CDDR_DL_FILE_DELETE_FAIL -309
//-함수 내부에서 파일에 대한 삭제 작업이 실패하였다.
#define CDDR_DL_FILE_SEEK_FAIL -310
//-함수 내부에서 파일 작업을 위한 SEEK 작업이 실패하였다.
#define CDDR_DL_CRYPTO_TYPE_INVALUD -401
//-함수 내부에서 암호화 작업을 수행하기 위한 암호화 타입이 올바르지 않다.
#define CDDR_DL_ENCRYPT_FAIL -402
//-함수 내부에서 암호화 작업이 실패하였다.
#define CDDR_DL_DECRYPT_FAIL -403
//-함수 내부에서 복호화 작업이 실패하였다.
#define CDDR_DL_DECRYPT_HTTP_PARAMETER_FAIL -404
//-함수 내부에서 HTTP PARAMETER 복호화 작업이 실패하였다.
#define CDDR_DL_ENCRYPT_HTTP_PARAMETER_FAIL -405
//-함수 내부에서 HTTP PARAMETER 암호화 작업이 실패하였다.
#define CDDR_DL_HEADER_PACKAGE_NOT_INIT -406
//-함수 내부에서 암호화 헤더의 패키징 작업이 초기화 되지 않았다.
#define CDDR_DL_SIGNATURE_MISMATCH -501
//-함수 내부에서 암호화 파일의 시그너쳐가 일치하지 않는다.
#define CDDR_DL_VERSION_MISMATCH -502
//-함수 내부에서 암호화 파일의 버전 정보가 일치하지 않는다.
#define CDDR_DL_RIGHT_OBJECT_INCORRECT -503
//-함수 내부에서 Right Object 정보가 올바르지 않다.
#define CDDR_DL_CONTENT_HEADER_MAKE_FAIL -505
//-함수 내부에서 Download DRM Header를 저장하기 위한 헤더 변환이 실패하였다.
#define CDDR_DL_RIGHT_OBJECT_PARSE_FAIL -507
//-함수 내부에서 Right Object에 대한 분석 작업이 실패하였다.
#define CDDR_DL_HEADER_FORM_INVALID -515
//-함수 내부에서 암호화 헤더의 형태가 정확하지 않다.
#define CDDR_DL_CONTENT_HEADER_INCORRECT -522
//-함수 내부에서 암호화 헤더의 데이터가 정확하지 않다.
#define CDDR_DL_WEB_REGISTER_DEVICE_PARAMETER_PARSE_FAIL -523
//-함수 내부에서 Register device를 위한 파라미터 파싱 작업이 실패하였다.
#define CDDR_DL_WEB_CONTENT_PLAY_PARAMETER_PARSE_FAIL -524
//-함수 내부에서 Web Play를 위한 파라 미터 파싱 작업이 실패하였다.
#define CDDR_DL_WEB_DOWNLOAD_PARAMETER_PARSE_FAIL -525
//-함수 내부에서 Content Download를 위한 파라 미터 파싱 작업이 실패하였다.
#define CDDR_DL_CONTENT_RIGHT_MISMATCH -526
//-함수 내부에서 이어 받기를 위한 암호화 헤더의 Right Object정보가 일치하지 않는다.
#define CDDR_DL_CONTENT_HEADER_INVALID -528
//-함수 내부에서 DRM파일의 헤더 형태가 올바르지 않다.
#define CDDR_DL_REGISTER_DEVICE_FAIL -530
//-함수 내부에서 디바이스 등록이 실패하였다.
#define CDDR_DL_CONTENT_LICENSE_FAIL -531
//-함수 내부에서 Content Challenge가 실패하였다.
#define CDDR_DL_ISSUE_RIGHT_FAIL -532
//-함수 내부에서 Content 권한 받기 작업이 실패하였다.
#define CDDR_DL_CHECK_RIGHT_EXPIRED -533
//-함수 내부에서 Content 재생을 위한 Right 체크가 실패하였다.
#define CDDR_DL_NOTIFY_DOWNLOAD_FAIL -534
//-함수 내부에서 Notify Download 작업이 실패하였다.
#define CDDR_DL_CONTENT_HEADER_TIME_NOT_START -535
//-Content의 사용기간이 아직시작되지 않았습니다.
#define CDDR_DL_CONTENT_HEADER_TIME_EXPIRED -536
//-Content의 사용기간이 만료되었습니다.
#define CDDR_DL_CONTENT_OFFLINE_EXPIRED_ONLINE_REQUIRED -537
//-Content의 오프라인 사용기간이 만료되었습니다. Content 사용을 위해서 네크워크 연결이 필요합니다.
#define CDDR_DL_NETWORK_ERROR -601
//-함수 내부에서 내트워크 작업 오류가 발생하였습니다.
#define CDDR_DL_SQL_INIT_FAIL -701
//-함수 내부에서 SQL Lite에 대한 초기화가 실패하였다.
#define CDDR_DL_SQL_SELECT_FAIL -702
//-함수 내부에서 Select 쿼리 작업이 실패하였다.
#define CDDR_DL_SQL_INSERT_FAIL -703
//-함수 내부에서 Insert 쿼리 작업이 실패하였다.
#define CDDR_DL_SQL_UPDATE_FAIL -704
//-함수 내부에서 Update 쿼리 작업이 실패하였다.
#define CDDR_DL_SQL_DELETE_FAIL -705
//-함수 내부에서 Delete 쿼리 작업이 실패하였다.

#endif
