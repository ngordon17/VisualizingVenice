//
//  VVLibrary.m
//  VVTemplate
//
//  Created by Kuang Han on 9/23/12.
//  Copyright (c) 2012 Visualizing Venice Team. All rights reserved.
//

#import "PublicLibrary.h"

@implementation PublicLibrary
@synthesize resourceFolderPath = _resourceFolderPath;

#pragma mark -
#pragma mark init
//init Data
- (id)init{
	if (self=[super init]) {
        _resourceFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Materials"];
	}
	return self;
}


#pragma mark -
#pragma mark File Operate

- (BOOL)checkFileExists:(NSString *)fileName
                  under:(NSString *)directory {
	return [[NSFileManager defaultManager] fileExistsAtPath:[directory stringByAppendingPathComponent:fileName]];
}


- (void)createFolder:(NSString *)folderName
               under:(NSString *)directory {
	if ([self checkFileExists:folderName under:directory]) {
		NSFileManager *fm=[NSFileManager defaultManager];
		[fm createDirectoryAtPath:[directory stringByAppendingPathComponent:folderName]
		  withIntermediateDirectories:YES
						   attributes:nil
								error:NULL];
	}
}

- (BOOL)deleteFile:(NSString *)fileName
              from:(NSString *)directory {
	NSFileManager *fm=[NSFileManager defaultManager];
	BOOL exist = [fm fileExistsAtPath:[directory stringByAppendingPathComponent:fileName]];
	if (exist) {
		[fm removeItemAtPath:[directory stringByAppendingPathComponent:fileName] error:nil];
	}
	return exist;
}

- (void)copyFile:(NSString *)fileName
		  from:(NSString *)initDirectory
		  to:(NSString *)targetDirectory {
	NSFileManager *fm=[NSFileManager defaultManager];
	BOOL exist=[fm fileExistsAtPath:[targetDirectory stringByAppendingPathComponent:fileName]];
	if (!exist) {
		[fm copyItemAtPath:[initDirectory stringByAppendingPathComponent:fileName] toPath:[targetDirectory stringByAppendingPathComponent:fileName] error:nil];
	}
}

- (void)deleteAllFilesUnder :(NSString *)directory{
	NSFileManager *fm=[NSFileManager defaultManager];
	NSInteger i;
	// look for files
	NSArray *array = [fm subpathsOfDirectoryAtPath:directory error:nil];
	if (array!=nil) {
		for(i=0;i<[array count];i++){
			[fm removeItemAtPath:[directory stringByAppendingPathComponent:[array objectAtIndex:i-1]]
							   error:nil];
		}
	}
}

- (NSString *)getResourceFilepath:(NSString *)fileName {
    return [self.resourceFolderPath stringByAppendingPathComponent:fileName];
}

- (NSString *)getStringFromFile:(NSString *) fileName {
    return [[NSString alloc] initWithData:[self getDataFromFile:fileName] encoding:NSUTF8StringEncoding];
}

- (UIImage *)getImageFromFile:(NSString *) fileName {
    return [[UIImage alloc] initWithData:[self getDataFromFile:fileName]];
}

- (NSData *)getDataFromFile:(NSString *) fileName {
    if ([self checkFileExists:fileName under:self.resourceFolderPath]) {
        return [NSData dataWithContentsOfFile:[self getResourceFilepath:fileName]];
    }
    else {
        NSLog(@"Warning: %@ does not exist", fileName);
        return NULL;
    }
}

- (void)saveData:(NSData*)data toFile:(NSString *)fileName {
	[self deleteFile:fileName from:self.resourceFolderPath];
	[data writeToFile:[self.resourceFolderPath stringByAppendingPathComponent:fileName] atomically:NO];
}


- (void)playSound:(NSString *)fileName {
	BOOL exist = [self checkFileExists:fileName under:self.resourceFolderPath];
	if (exist) {
		SystemSoundID IdSound;
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[self.resourceFolderPath stringByAppendingPathComponent:fileName]], &IdSound);
		AudioServicesPlaySystemSound(IdSound);
	}
}



@end
