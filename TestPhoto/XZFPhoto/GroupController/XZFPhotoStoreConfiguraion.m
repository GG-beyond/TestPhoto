//
//  XZFPhotoStoreConfiguraion.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/30.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoStoreConfiguraion.h"
NSString * ConfigurationCameraRoll = @"Camera Roll";
NSString * ConfigurationHidden = @"Hidden";
NSString * ConfigurationSlo_mo = @"Slo-mo";
NSString * ConfigurationScreenshots = @"Screenshots";
NSString * ConfigurationVideos = @"Videos";
NSString * ConfigurationPanoramas = @"Panoramas";
NSString * ConfigurationTime_lapse = @"Time-lapse";
NSString * ConfigurationRecentlyAdded = @"Recently Added";
NSString * ConfigurationRecentlyDeleted = @"Recently Deleted";
NSString * ConfigurationBursts = @"Bursts";
NSString * ConfigurationFavorite = @"Favorite";
NSString * ConfigurationSelfies = @"Selfies";


static NSArray <NSString *>*  groupNames;
@implementation XZFPhotoStoreConfiguraion
+(void)initialize
{
    if (self == [XZFPhotoStoreConfiguraion class])
    {

        groupNames = @[NSLocalizedString(ConfigurationCameraRoll, @""),
                       NSLocalizedString(ConfigurationSlo_mo, @""),
                       NSLocalizedString(ConfigurationFavorite, @""),
                       NSLocalizedString(ConfigurationScreenshots, @""),
                       NSLocalizedString(ConfigurationVideos, @""),
                       NSLocalizedString(ConfigurationPanoramas, @""),
                       NSLocalizedString(ConfigurationRecentlyAdded, @""),
                       NSLocalizedString(ConfigurationSelfies, @"")];
    }
}

-(NSArray *)groupNamesConfig
{
    return groupNames;
}

-(void)setGroupNames:(NSArray<NSString *> *)newGroupNames
{
    groupNames = newGroupNames;
    
    [self localizeHandle];
}

//初始化方法
-(instancetype)initWithGroupNames:(NSArray<NSString *> *)groupNames
{
    if (self = [super init])
    {
        [self setGroupNames:groupNames];
    }
    
    return self;
}


+(instancetype)storeConfigWithGroupNames:(NSArray<NSString *> *)groupNames
{
    return [[self alloc]initWithGroupNames:groupNames];
}



/** 本地化语言处理 */
- (void)localizeHandle
{
    NSMutableArray <NSString *> * localizedHandle = [NSMutableArray arrayWithArray:groupNames];
    
    for (NSUInteger i = 0; i < localizedHandle.count; i++)
    {
        [localizedHandle replaceObjectAtIndex:i withObject:NSLocalizedString(localizedHandle[i], @"")];
    }
    
    groupNames = [NSArray arrayWithArray:localizedHandle];
}

@end
