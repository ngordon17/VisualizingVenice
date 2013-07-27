//
//  VVLibrary.h
//  VVTemplate
//
//  Created by Kuang Han on 9/23/12.
//  Copyright (c) 2012 Visualizing Venice Team. All rights reserved.
//
#import <AudioToolbox/AudioServices.h>

@interface PublicLibrary : NSObject

@property (nonatomic, retain) NSString *resourceFolderPath;


#pragma mark -
#pragma mark File Operate

- (BOOL)checkFileExists:(NSString *)fileName
                    under:(NSString *)directory;

- (void)createFolder:(NSString *)folderName
				under:(NSString *)directory;

- (BOOL)deleteFile:(NSString *)fileName
			from:(NSString *)directory;

- (void)copyFile:(NSString *)fileName
		  from:(NSString *)initDirectory
		  to:(NSString *)targetDirectory;

- (void)deleteAllFilesUnder :(NSString *)directory;

- (NSString *)getResourceFilepath:(NSString *) fileName;
- (NSString *)getStringFromFile:(NSString *) fileName;
- (UIImage *)getImageFromFile:(NSString *) fileName;
- (NSData *)getDataFromFile:(NSString *) fileName;
- (void)saveData:(NSData*)data toFile:(NSString *)fileName;

- (void)playSound:fileName;

@end
