//
//  KuQUIEngine.h
//  KuQ
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class CL_AudioRecorder;
@protocol FSCL_AudioDelegate<NSObject>
//录音保存完毕回调
-(void)stopRecorderEnd:(CL_AudioRecorder*)_record;
//录音结束，并删除录音文件
-(void)stopAndDelRecorderEnd:(CL_AudioRecorder*)_record;
//录音结束，删除所有录音文件
-(void)stopAndDelAllRecorderEnd:(CL_AudioRecorder*)_record;
//出错处理
-(void)errorRecorderDidOccur:(CL_AudioRecorder*)_record;
@end

@interface CL_AudioRecorder : NSObject<AVAudioRecorderDelegate>{
    int m_audioFileCount;
@private
    NSTimer *_recordTimer;
}

@property (nonatomic) int  m_audioFileCount;
@property (nonatomic, assign) void (^finishRecordingBlock)(CL_AudioRecorder *recorder,BOOL success);
@property (nonatomic, assign) void (^encodeErrorRecordingBlock)(CL_AudioRecorder *recorder,NSError *error);
@property (nonatomic, assign) void (^receivedRecordingBlock)(CL_AudioRecorder *recorder,float peakPower,float averagePower,float currentTime);

@property (nonatomic, strong,readonly) AVAudioRecorder* audioRecorder;
@property (nonatomic, strong,readonly) NSString *recorderingPath;
@property (nonatomic, strong) NSString *recorderingFileName;
@property (nonatomic, assign,readonly) BOOL deletedRecording;
@property (nonatomic, assign) id<FSCL_AudioDelegate> clAudioDelegate;

- (id)initWithFinishRecordingBlock:(void (^)(CL_AudioRecorder *recorder,BOOL success))finishRecordingBlock 
         encodeErrorRecordingBlock:(void (^)(CL_AudioRecorder *recorder,NSError *error))encodeErrorRecordingBlock
            receivedRecordingBlock:(void (^)(CL_AudioRecorder *recorder,float peakPower,float averagePower,float currentTime))receivedRecordingBlock;

- (BOOL)startRecord;
- (BOOL)startRecordForDuration: (NSTimeInterval) duration;

- (void)stopRecord;
- (void)stopAndDeleteRecord;
- (void)stopAndDeleteAllRecords;

- (void)cleanAllBlocks;

@end

