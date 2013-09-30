//
//  mgGlobal.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 3. 22..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#ifndef SmartPlayer_mgGlobal_h
#define SmartPlayer_mgGlobal_h

// menu
#define MENU_IDX_LECPLAYER  0
#define MENU_IDX_MESSAGE    1
#define MENU_IDX_STOPWATCH  2
#define MENU_IDX_CONFIG     3

// common
#define APP_VERSION             @"1.0.0"  // 앱 버전
#define CENTER_PHONE_NUMBER     @"1599-1010" // 콜센터 번호

//스트리밍 공통 URL
#define STREAMING_URL           @"http://127.0.0.1:"

//// timer
#define TIMER_MARK_HOUR     5   // 타이머 기준시는 오전 5시

// 통신
#define COMM_NOTACCESS          0
#define COMM_WIFI               1
#define COMM_WAAN               2

// web & urls
//#define URL_DOMAIN              @"http://next.megastudy.net"                        //공통 주소
#define URL_DOMAIN              @"http://www.megastudy.net"

#define URL_DOMAIN_LOGIN        @"https://www.megastudy.net"                        //로그인 주소
//#define URL_DOMAIN_LOGIN        @"http://next.megastudy.net"                        //개발

#define URL_FILE_DOMAIN         @"http://file1.megastudy.net"

#define URL_DEVICE_INFO         @"/mobile/app/main/app_req_start.asp"               //기기정보등록
#define URL_LOGIN               @"/mobile/app/main/app_req_submit.asp"              //로그인
#define URL_AUTO_LOGIN          @"/mobile/app/main/app_req_submit_auto.asp"         //자동로그인
#define URL_BASIC_SETTING       @"/mobile/app/config/my_info.asp"                   //기본설정값
#define URL_CONFIG_SET          @"/mobile/app/config/set.asp"                       //기본설정
#define URL_LOGOUT              @"/mobile/app/main/app_logout.asp"                  //로그아웃

#define URL_MYLEC               @"/mobile/app/lecture/list.asp"                     //수강중인 강좌
#define URL_MYLEC_LIST          @"/mobile/app/mypage/lecture_view.asp"              //수강중인 강좌 리스트(강의실)

#define URL_LECTURE_FORM        @"/mobile/app/lecture/set_date_stop.asp"
#define URL_LECTURE_DATE        @"/mobile/app/lecture/set_date_sql.asp"             //일시정지 신청
#define URL_LECTURE_ENDDATE     @"/mobile/app/lecture/set_date_end_sql.asp"         //일시정지 신청해지

#define URL_HIGH_PLAY           @"/mobile/app/player/player_high.asp"               //고화질(Play)
#define URL_SD_PLAY             @"/mobile/app/player/player_norm.asp"               //일반화질(Play)

#define URL_QNA_LIST            @"/mobile/app/teacher/qna/list.asp"                 //질문답변 리스트
#define URL_QNADETAIL_LIST      @"/mobile/app/teacher/qna/wv_view.asp"              //질문내용 보기
#define URL_QNATYPE_LIST        @"/mobile/app/teacher/qna/ans_type.asp"             //질문대상 리스트
#define URL_QNAEDIT             @"/mobile/app/teacher/qna/modify.asp"               //질문수정
#define URL_QNADEL              @"/mobile/app/teacher/qna/action.asp"               //질문삭제

//#define URL_QNASEND             @"/fileserver/app/page/smart/teacher/next_teacher_bbs_2007_sql.asp" //개발
#define URL_QNASEND             @"/fileserver/app/page/smart/teacher/teacher_bbs_2007_sql.asp" //질문보내기

#define URL_TALK_LIST           @"/mobile/app/mypage/talk/list.asp"                 //마이톡 리스트
#define URL_TALK_ACTION         @"/mobile/app/mypage/talk/action.asp"               //마이톡 액션
#define URL_TALK_VIEW           @"/mobile/app/mypage/talk/wv_view.asp"              //마이톡 내용보기
#define URL_TALK_SEARCH         @"/mobile/app/mypage/talk/search.asp"               //마이톡 찾기

#define URL_SEARCH_LIST         @"/mobile/app/lecture/step/study_typeA_ax.asp"      //강좌 찾기
#define URL_SEARCH_LIST2         @"/mobile/app/lecture/step/study_typeB_ax.asp"     //강좌 찾기(선생님)
#define URL_SEARCH_CHR_LIST     @"/mobile/app/lecture/step/wv_chr_list.asp"         //강좌 과목리스트
#define URL_SEARCH_TEC_LIST     @"/mobile/app/lecture/step/wv_tec_list.asp"         //강좌 과목리스트(선생님)

#define URL_DEVICE_CHECK        @"/Player/MegaPlayer/PlayerApp/DeviceInfo.asp"      //기기등록여부 확인

#define URL_DOWNLOADURL         @"/player/MegaPlayer/PlayerApp/DownloadDRMMake.asp" //강의 다운로드
#define URL_BOOKMARK            @"/player/megaplayer/playerapp/PlayerMobileLecHis.asp"      //북마크

#define URL_DEVICE_LIST         @"/mobile/app/config/device/list.asp"               //등록기기 보기

#define URL_CONFIG_GET_DDAY     @"/mobile/app/config/dday/list.asp"                 //dday 리스트
#define URL_CONFIG_SET_DDAY     @"/mobile/app/config/dday/set.asp"                  //dday 설정

// FAQ
#define URL_FAQ_CAT             @"/mobile/app/config/faq/cat.asp"
#define URL_FAQ_LIST            @"/mobile/app/config/faq/list.asp"
#define URL_FAQ_DETAIL          @"/mobile/app/config/faq/wv_view.asp"

// 공지사항
#define URL_NOTICE_LIST         @"/mobile/app/config/notice/list.asp"               //공지사항목록
#define URL_NOTICE_DETAIL       @"/mobile/app/config/notice/wv_view.asp"            //공지사항디테일

// 의견보내기
#define URL_OPI_TYPE            @"/mobile/app/config/opinion/title_type.asp"                // 의견보내기 타이틀 종류
//#define URL_OPI_SEND            @"/fileserver/app/page/smart/config/next_opinion_sql.asp"   //개발
#define URL_OPI_SEND            @"/fileserver/app/page/smart/config/opinion_sql.asp"   //의견보내기

//#define URL_FILEUPLOAD          @"/fileserver/app/page/smart/profile/next_file_upload_profile_v1.asp"   //개발
#define URL_FILEUPLOAD          @"/fileserver/app/page/smart/profile/file_upload_profile_v1.asp"   //등록/수정

#define URL_BOOKMARK_DEL        @"/mobile/app/mypage/lecture_bookmark.asp"          //북마크 삭제

//USERDEFAULT
#define MYTALK_ID               @"mytalk_id"
#define HOME_LOAD_COUNT         @"home_load_count"
#define SETTING_NUM             @"settingNum"
#define DDAY_NUM                @"ddayNum"
#define DEVICE_ID               @"device_id"

//BADGE COUNT
#define MYTALK_BADGE            @"mytalk_badge"
#define LEC_BADGE               @"lec_badge"

// design
#define TABBAR_HEIGHT 93

#define PROGRESS				@"progress"

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0]

//서버메시지 응답 팝업 태그
#define TAG_MSG_NONE            1001
#define TAG_MSG_FAIL			1002
#define TAG_MSG_LECDOING        1003
#define TAG_MSG_LECDEL          1004
#define TAG_MSG_STREAMPLAY      1005
#define TAG_MSG_DOWNLOADPLAY    1006
#define TAG_MSG_DEVICE_SUBMIT   1007
#define TAG_MSG_TALK_STORAGE    1008
#define TAG_MSG_TALK_DEL        1009
#define TAG_MSG_QNA_DEL         1010
#define TAG_MSG_WRITE_SUCCESS   1011
#define TAG_MSG_WRITE_CANCEL    1012
#define TAG_MSG_IMAGEDEL        1013
#define TAG_MSG_TALK_SUCCESS    1014
#define TAG_MSG_NETWORK         1015
#define TAG_MSG_STREMCONTINUE   1016
#define TAG_MSG_DOWNCONTINUE    1017
#define TAG_MSG_DOWNALLDEL      1018
#define TAG_MSG_DOWN_BACK       1019
#define TAG_MSG_DOWNLOADING     1020
#define TAG_MSG_BOOKMARK        1021
#define TAG_MSG_BOOKMARK_DEL    1022

#define NOTI_REACHABILTY_CHANGE @"NOTI_REACHABILTY_CHANGE"

#endif
