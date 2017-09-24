//
//  FileModel.h
//  notary
//
//  Created by 肖 喆 on 13-3-27.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  enum {
    
    kVideoFile = 0,
    kPhotoFile,
    kVoiceFile,
    kFolderFile,         //由于文件与文件夹出现了一些混淆，所以增加一个变量来区分
    kOtherFile           //ios原生不支持的文件类型
}FileType;
typedef enum{
    
    kUploadFile = 0,  
    kDownLoadFile,
    
}FileActionType;

enum {
    
    ZIPFILE_DOWNLOAD_NO = 0,  //没有下载
    ZIPFILE_DOWNLOADING = 1,  //下载中
    ZIPFILE_DOWNLOADED  = 2,  //下载完成
    
};

@interface FileModel : NSObject
{

    NSString * _folderId;
    NSString * _fid;             //本地数据库id
    NSString * _srcid;           //上传返回的文件id
    NSString * _serverFileId;    //服务器端id
    
    NSString * _name;
    NSString * _targetName;        //下载后本地存储的路径
    NSURL *    _path;              //上传时相册路径
    UIImage *  _image;
    NSData *   _data;             //保存字节流

    NSString * _folderName;
    
    NSString * _size;
    NSString * _receivedSize;
    FileType   _type;              //是图片还是视频,音频
    BOOL       _isFirstUpload;
    BOOL       _isFirstDownload;
    BOOL       _isDownLoading;
    int        _downStatus;        //下载的三种状态
    BOOL       _isFolder;          //是否是文件夹

    NSString * _datatime;
    FileActionType _actionType;   //是下载 还是上传
    NSString * _message;
    
    int        _isEncrypt;       //是否解密  0为未解密  1为解密成功
    NSString * _md5;             //记录文件的md5
}
@property (nonatomic, strong)NSString * fid;
@property (nonatomic, strong)NSString * folderId;
@property (nonatomic, strong)NSString * serverFileId;
@property (nonatomic, strong)NSString * srcid;

@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSURL * path;
@property (nonatomic, strong)UIImage * image;
@property (nonatomic, strong)NSData *   data;
@property (nonatomic, strong)NSString * folderName;
@property (nonatomic, strong)NSString * targetName;
@property (nonatomic, strong)NSString * size;
@property (nonatomic, strong)NSString * receivedSize;
@property (nonatomic, strong)NSString * message;
@property  BOOL       isFirstUpload;
@property  BOOL       isFirstDownload;
@property  BOOL       isDownLoading;
@property  BOOL       isFolder;
@property  FileType type;
@property  int downStatus;
@property  int isEncrypt;
@property BOOL * isAlreadySubmit; //是否已经申请公正

@property (nonatomic, strong) NSString * uid;

@property (nonatomic, strong) NSString * datatime;
@property FileActionType actionType;
@property (nonatomic, strong) NSString * md5;

+ (FileType)getFileType:(NSString *)name;
+ (NSString *)getExtendName:(NSString *)name;
@end
