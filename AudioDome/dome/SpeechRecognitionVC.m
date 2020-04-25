//
//  SpeechRecognitionVC.m
//  AudioDome
//
//  Created by 颜学宙 on 2020/4/19.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "SpeechRecognitionVC.h"
#import <AVFoundation/AVFoundation.h>

#import <Speech/Speech.h>
@interface SpeechRecognitionVC ()<AVSpeechSynthesizerDelegate,SFSpeechRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)AVSpeechSynthesizer *speechManager;//

@property(nonatomic,strong)SFSpeechRecognizer *speechRecognizer;//语音识别器
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *recognitionRequest;//语音识别请求
@property(nonatomic,strong)SFSpeechRecognitionTask *recognitionTask;//语音任务管理器
@property(nonatomic,strong)AVAudioEngine *audioEngine;//语音控制器
@property (weak, nonatomic) IBOutlet UIButton *swicthBut;

@end

@implementation SpeechRecognitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        BOOL isButtonEnabled = false;
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                isButtonEnabled=true;
                NSLog(@"可以语音识别");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                isButtonEnabled=false;
                NSLog(@"用户为授权使用语音识别");
                break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                isButtonEnabled=false;
                NSLog(@"语音识别在这台设备上收到限制");
                break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                isButtonEnabled=false;
                NSLog(@"语音识别为授权");
                break;
            default:
                break;
        }
    }];
}
- (IBAction)textChangeAdioTap:(UIButton *)sender {
    NSString *text=self.textView.text;
    if (text!=nil&&![@"" isEqualToString:[text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        _speechManager=[[AVSpeechSynthesizer alloc]init];
        _speechManager.delegate=self;

        AVSpeechUtterance *aut=[AVSpeechUtterance speechUtteranceWithString:text];
        
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        aut.voice=voice;
        aut.rate=0.5;
        [_speechManager speakUtterance:aut];
    }
}
- (IBAction)audioChangeToTextTap:(UIButton *)sender {
    if ([self.audioEngine isRunning]) {
        [self endRecording];
        [self.swicthBut setTitle:@"开始录音" forState:UIControlStateNormal];
    }else{
        [self startRecording];
        [self.swicthBut setTitle:@"关闭" forState:UIControlStateNormal];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"开始语音处理");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"语音处理完成");
    synthesizer.delegate=nil;
    
}

// Called when the availability of the given recognizer changes
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        self.swicthBut.enabled=YES;
        [self.swicthBut setTitle:@"开始录音" forState:UIControlStateNormal];
    }else{
        self.swicthBut.enabled=NO;
        [self.swicthBut setTitle:@"语音识别不可用" forState:UIControlStateNormal];
    }
}
#pragma mark -停止录音
-(void)endRecording{
    [self.audioEngine stop];
    
    
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
        _recognitionRequest=nil;
    }
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask=nil;
    }
    if (_speechRecognizer) {
        _speechRecognizer.delegate=nil;
        _speechRecognizer=nil;
    }
    
//    self.audioEngine=nil;
}
#pragma mark -开始录音
-(void)startRecording{
    if(self.recognitionTask){
        [self.recognitionTask cancel];
        self.recognitionTask=nil;
    }
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    NSError *error;
    BOOL audioBool=[audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    BOOL audioBool1=[audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    BOOL audioBool2=[audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    if (audioBool||audioBool1||audioBool2) {
        NSLog(@"可以使用");
    }else{
        NSLog(@"这里说明有的功能不支持");
    }
    self.recognitionRequest=[[SFSpeechAudioBufferRecognitionRequest alloc]init];
    AVAudioInputNode *inputNode=self.audioEngine.inputNode;
    NSAssert(inputNode, @"录入设备没准备好");
    NSAssert(self.recognitionRequest, @"请求初始化失败");
    self.recognitionRequest.shouldReportPartialResults=true;
    __weak typeof(self) weakSelf = self;
    //开始识别任务
    self.recognitionTask =[self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        BOOL isFinal=false;
        if (result) {
            strongSelf.textView.text=[[result bestTranscription]formattedString];//语音转文本
            isFinal=[result isFinal];
        }
        if (error||isFinal) {
            [strongSelf.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionRequest=nil;
            strongSelf.recognitionTask=nil;
            [strongSelf.swicthBut setTitle:@"开始录音" forState:UIControlStateNormal];
            strongSelf.swicthBut.enabled=true;
            strongSelf.audioEngine=nil;
        }
    }];
    AVAudioFormat *recordingFormat=[inputNode outputFormatForBus:0];
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

                if(strongSelf.recognitionRequest) {

                    [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];

                }

    }];
    [self.audioEngine prepare];
    BOOL audioEngineBool=[self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
    self.textView.text=@"正在录音....";
    NSLog(@"%d",audioEngineBool);
}
#pragma mark - 语音识别
-(SFSpeechRecognizer *)speechRecognizer{
    if (!_speechRecognizer) {
        NSLocale *cale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        _speechRecognizer=[[SFSpeechRecognizer alloc]initWithLocale:cale];
        _speechRecognizer.delegate=self;
    }
    return _speechRecognizer;
}
#pragma mark---创建录音引擎
-(AVAudioEngine *)audioEngine{
    if (!_audioEngine) {
        _audioEngine=[[AVAudioEngine alloc]init];
    }
    return _audioEngine;
}
#pragma mark---识别本地音频文件

- (void)recognizeLocalAudioFile:(UIButton*)sender {
/*
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    SFSpeechRecognizer *localRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];

    NSURL *url =[[NSBundle mainBundle] URLForResource:@"录音.m4a" withExtension:nil];

    if(!url)return;

    SFSpeechURLRecognitionRequest *res =[[SFSpeechURLRecognitionRequest alloc] initWithURL:url];

    __weak typeof(self) weakSelf = self;

    [localRecognizer recognitionTaskWithRequest:resresultHandler:^(SFSpeechRecognitionResult*_Nullableresult,NSError*_Nullableerror) {

        if(error) {

            NSLog(@"语音识别解析失败,%@",error);

        }

        else

        {

            weakSelf.labText.text = result.bestTranscription.formattedString;

        }

    }];*/

}


@end
