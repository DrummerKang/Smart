//
//  CoreProtocolErrCode.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 27..
//

#ifndef AquaPlayer_CoreProtocolErrCode_h
#define AquaPlayer_CoreProtocolErrCode_h

#define CDDR_DL_PROTOCOL_OPERATION_SUCCESS 0
//프로토콜이 성공적으로 수행되었다.
//	성공
//	SUCCESS

#define CDDR_DL_PROTOCOL_CUSTOMER_SERVER_ERROR 101
//고객 서버에서 오류가 발생하였다.
//	고객서버 오류
//	CUSTOMER SERVER ERROR

#define CDDR_DL_PROTOCOL_AQUA_DRM_SERVER_ERROR 102
//DRM 서버에서 오류가 발생하였다.
//	DRM 서버 오류
//	DRM SERVER ERROR

#define CDDR_DL_PROTOCOL_CUSTOMER_SERVER_NOT_FOUND 103
//고객 서버를 찾을 수 없다
//	고객서버 탐색 오류
//	CUSTOMER SERVER IS NOT FOUND

#define CDDR_DL_PROTOCOL_AQUA_DRM_SERVER_NOT_FOUND 104
//DRM 서버를 찾을 수 없다.
//	DRM 서버 탐색 오류
//	DRM SERVER IS NOT FOUND

#define CDDR_DL_PROTOCOL_INVALID_PARAMETER 105
//프로토콜의 데이터가 올바르지 않다.
//	프로토콜 데이터가 올바르지 않습니다.
//	INVALID PARAMETER

#define CDDR_DL_PROTOCOL_RIGHT_NOT_FOUND 201
//Right발급 요청에 대한 Right Object가 존재하지 않는다.
//	사용권한이 없습니다
//	LICENSE IS NOT FOUND

#define CDDR_DL_PROTOCOL_RIGHT_EXPIRED 202
//Right Object의 권한이 만료되었다.
//	사용권한이 만료되었습니다
//	LICENSE IS EXPIRED

#define CDDR_DL_PROTOCOL_RIGHT_VALID 203
//Right Object가 현재까지는 유효하다.
//	사용권한이 유효합니다
//	LICENSE IS VALID

#define CDDR_DL_PROTOCOL_UPDATED_RIGHT 204
//Right 갱신 요청에 따라서 정상적으로 Right Object가 발급되었다.
//	사용권한 갱신을 성공하였습니다.
//	SUCCESS TO UPDATE LICENSE.

#define CDDR_DL_PROTOCOL_ISSUE_RIGHT 205
//Right 발급 요청에 따라서 정상적으로 Right Object가 발급되었다.
//	사용권한 획득에 성공하였습니다.
//	SUCCESS TO ISSUE LICENSE.

#define CDDR_DL_PROTOCOL_RIGHT_NOT_STARTED 206
//사용권한이 시작되지 않았습니다.
//	사용가능 기간이 아닙니다.
//	LICENSE IS NOT STARTED.

#define CDDR_DL_PROTOCOL_ALREADY_REGISTERED_DEVICE 301
//Device가 이미 등록 되어있다.
//	이미 등록된 기기입니다.
//	DEVICE IS ALREADY REGISTERED.

#define CDDR_DL_PROTOCOL_UNREGISTER_DEVICE 302
//해당 Device가 등록되어 있지 않다.
//	등록되지 않은 기기입니다.
//	DEVICE IS UNREGISTERED.

#define CDDR_DL_PROTOCOL_DEVICE_IS_REGISTERED_BY_ANOTHER_USER 304
//Device가 다른 유저에 의해서 이미 등록 되었다.
//	다른 사용자에 의해 등록된 기기입니다.
//	DEVICE IS REGIST

#define CDDR_DL_PROTOCOL_USER_EXCEEDED_ALLOWED_DEVICE_COUNT 305
//유저에게 할당된 Device 개수가 초과 되었다.
//	사용자에게 할당된 기기대수를 초과하였습니다.
//	DEVICE COUNT IS EXCEEDED LIMIT.

#define CDDR_DL_PROTOCOL_USER_NOT_FOUND 401
//지정된 유저가 존재하지 않음.
//	존재하지 않는 사용자 입니다.
//	USER IS NOT FOUND.

#define CDDR_DNP_PROTOCOL_INVALID_HASH 501
//프로토콜 해시 검증에 실패함.
//	인증된 프로토콜이 아닙니다.
//	PROTOCOL HASH IS INVALID

#define CDDR_DNP_PROTOCOL_EXPIRED_HASH 502
//프로토콜 유효시간이 경과됨.
//	프로토콜 유효시간 경과
//	PROTOCOL HASH IS EXPIRED.

#endif
