//
//  CustomPlayAudioVC.m
//  AudioDome
//
//  Created by 颜学宙 on 2020/4/19.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "CustomPlayAudioVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface CustomPlayAudioVC ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *audioInfoLabel;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property(nonatomic,strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UISlider *volSlider;
@end

@implementation CustomPlayAudioVC
-(void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *playMusicParh=[[NSBundle mainBundle]pathForResource:@"test1" ofType:@"mp3"];
    if (playMusicParh) {
        [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *musicUrl=[NSURL fileURLWithPath:playMusicParh];
        _audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
        _audioPlayer.delegate=self;
        _audioPlayer.meteringEnabled=YES;//音频测量开关
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(monitor) userInfo:nil repeats:YES];
        
    }
}
-(void)monitor{
    NSUInteger channels = self.audioPlayer.numberOfChannels;
    NSTimeInterval duration=self.audioPlayer.duration;
    NSLog(@"[self.audioPlayer peakPowerForChannel:1] = %f",[self.audioPlayer peakPowerForChannel:1]);
    [self.audioPlayer updateMeters];
    NSString *audioInfoValue=[NSString stringWithFormat:@"%f , %f\n  channels=%lu duration = %lu \n currentTime=%lu",[self.audioPlayer peakPowerForChannel:0],[self.audioPlayer peakPowerForChannel:1],channels,(long)duration,(long)self.audioPlayer.currentTime];
    self.audioInfoLabel.text=audioInfoValue;
    self.progressView.progress=self.audioPlayer.currentTime/duration;
}
- (IBAction)payTap:(UIButton *)sender {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        [self.timer invalidate];
    }else{
        [self.audioPlayer play];
        [self.timer fire];
    }
    
}
- (IBAction)stopTap:(UIButton *)sender {
    self.progressView.progress=0.0f;
//    self.volSlider.value=0;
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
    }
}
- (IBAction)nextTap:(UIButton *)sender {
}
- (IBAction)lastTap:(UIButton *)sender {
}
- (IBAction)mute:(id)sender {
    self.audioPlayer.volume=0;
    self.volSlider.value=0;
}
- (IBAction)cycTap:(UIStepper *)sender {
    self.audioPlayer.numberOfLoops=sender.value;
}

- (IBAction)paySlider:(UISlider *)sender {
    [self.audioPlayer pause];
    [self.audioPlayer setCurrentTime:(NSTimeInterval)sender.value*self.audioPlayer.duration ];
    [self.audioPlayer play];
}
- (IBAction)volTap:(UISlider *)sender {
    self.audioPlayer.volume=sender.value;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完成");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}
@end
