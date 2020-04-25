//
//  AudioSystemSoundVCViewController.m
//  AudioDome
//
//  Created by 颜学宙 on 2020/4/16.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "AudioSystemSoundVCViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AudioSystemSoundVCViewController ()

@end

void SoundFinishedPlaying(SystemSoundID sound_id,void *user_data){
    AudioServicesRemoveSystemSoundCompletion(sound_id);
    AudioServicesDisposeSystemSoundID(sound_id);
}
@implementation AudioSystemSoundVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)configUI{
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"震动" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.frame=CGRectMake(50, 80, 100, 50);
    but.tag=1;
    [but addTarget:self action:@selector(butTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    UIButton *but1=[UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitle:@"系统声音" forState:UIControlStateNormal];
    [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but1.frame=CGRectMake(50, 140, 100, 50);
    but1.tag=2;
    [but1 addTarget:self action:@selector(butTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    UIButton *but2=[UIButton buttonWithType:UIButtonTypeCustom];
    [but2 setTitle:@"提示音" forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but2.frame=CGRectMake(50, 200, 100, 50);
    but2.tag=1;
    [but2 addTarget:self action:@selector(butTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but2];
}
-(void)butTap:(UIButton *)but{
    NSInteger tag=but.tag;
    NSString *deviceModel=[UIDevice currentDevice].model;
    if (tag==1) {
        if ([deviceModel isEqualToString:@"iPhone"]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持震动" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }else if(tag==2){
        NSURL *systemSound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"caf"]];
        //创建ID
        SystemSoundID systemSoundId;
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(systemSound_url), &systemSoundId);
       //注册callback
        AudioServicesAddSystemSoundCompletion(systemSoundId, NULL, NULL, SoundFinishedPlaying, NULL);
       //播放系统声音
        AudioServicesPlaySystemSound(systemSoundId);//静音时无声音
    }else if(tag==3){
        NSURL *systemSound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"caf"]];
               //创建ID
               SystemSoundID systemSoundId;
               AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(systemSound_url), &systemSoundId);
              //注册callback
               AudioServicesAddSystemSoundCompletion(systemSoundId, NULL, NULL, SoundFinishedPlaying, NULL);
              //播放系统声音
               AudioServicesPlayAlertSound(systemSoundId);//静音不静音都有声音
    }
    
}
@end
