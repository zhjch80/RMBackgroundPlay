//
//  RootViewController.m
//  RMMusicBackgroudPlay
//
//  Created by runmobile on 14-12-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>

@interface RootViewController (){
    AVAudioPlayer *player;
}

@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self configPlayingInfoCenter];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)configPlayingInfoCenter {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"你是我的眼" forKey:MPMediaItemPropertyTitle];//音乐名
        [dict setObject:@"林宥嘉" forKey:MPMediaItemPropertyArtist];//歌手
        [dict setObject:@"一天" forKey:MPMediaItemPropertyAlbumTitle];//专辑名称
        //总时长，可根据音乐文件实际时长
        [dict setObject:[NSNumber numberWithFloat: 100.0] forKey:MPMediaItemPropertyPlaybackDuration];
        //专辑图片
        UIImage *image = [UIImage imageNamed:@"shu.jpg"];
        MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artWork forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //控制中心
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                //暂停/播放切换
                NSLog(@"暂停/播放");
                if ([player isPlaying]) {
                    [player pause];
                }else{
                    [player play];
                }
                break;
            }
            case UIEventSubtypeRemoteControlPlay:{
                //播放
                NSLog(@"播放");
                [player play];
                break;
            }
            case UIEventSubtypeRemoteControlPause:{
                //暂停
                NSLog(@"暂停");
                [player pause];
                break;
            }
            case UIEventSubtypeRemoteControlStop:{
                //停止
                NSLog(@"停止");
                [player stop];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:{
                //上一首
                NSLog(@"上一首");
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:{
                //下一首
                NSLog(@"下一首");
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingBackward:{
                NSLog(@"UIEventSubtypeRemoteControlBeginSeekingBackward");
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingBackward:{
                //开始后退
                NSLog(@"UIEventSubtypeRemoteControlEndSeekingBackward");
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingForward:{
                NSLog(@"UIEventSubtypeRemoteControlBeginSeekingForward");
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingForward:{
                NSLog(@"UIEventSubtypeRemoteControlEndSeekingForward");
                break;
            }
                
            default:
                
                break;
        }
    }
}

- (IBAction)play:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"你是我的眼" ofType:@"mp3"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSURL *url = [NSURL fileURLWithPath:path];
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [player prepareToPlay];
        
        [player setVolume:2];
        
        //设置循环次数，－1时一直循环
        
        player.numberOfLoops = -1;
        
        [player play];
        
        NSLog(@"duration:%f",[player duration]);
    }
    
}
@end
