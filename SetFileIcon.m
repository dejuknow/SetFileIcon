//
// Created 02 July 2010 by Hank McShane
// version 0.1
// requires Mac OS X 10.4 or higher
//
// Use this to add an image file as the custom icon to a file or folder
// You can also remove the custom icon from a file/folder
//
// Usage: SetFileIcon
// [-h] show the help text
// [-image <imagePath>] path to the image to be used for the icon
// [-file <filePath>] path to the file to set the icon
// [-removeCustomIcon] removes the custom icon for the file
//
// Examples:
// This sets the image as the custom icon for the file:
// SetFileIcon -image /path/to/image -file /path/to/file
//
// This removes the custom icon from the file:
// SetFileIcon -removeCustomIcon -file /path/to/file
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

void printHelp();


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	BOOL removeFileIcon = NO;
	
	// is help being requested
	NSArray* pInfo = [NSArray arrayWithArray:[[NSProcessInfo processInfo] arguments]];
	if ([pInfo count] == 1) {
		printHelp();
		return 0;
	} else if ([[pInfo objectAtIndex:1] isEqualToString:@"-h"]) {
		printHelp();
		return 0;
	} else if ([pInfo containsObject:@"-removeCustomIcon"]) {
		removeFileIcon = YES;
	}
	
	// get the file and make sure it exists
	NSString* filePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"file"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSString* error = [NSString stringWithFormat:@"Error: the file could not be found: %@\n", filePath];
		fprintf(stderr, [error UTF8String]);
		return 1;
	}
	
	// set the icon to the file
	if (removeFileIcon) {
		[[NSWorkspace sharedWorkspace] setIcon:nil forFile:filePath options:0];
	} else {
		// get the image and make sure it exists
		NSString* imagePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"image"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
			NSString* error = [NSString stringWithFormat:@"Error: the image could not be found: %@\n", imagePath];
			fprintf(stderr, [error UTF8String]);
			return 1;
		}
		
		NSImage* image = [[NSImage alloc] initWithContentsOfFile:imagePath];
		[[NSWorkspace sharedWorkspace] setIcon:image forFile:filePath options:0];
		[image release];
	}

	
    [pool drain];
    return 0;
}

void printHelp() {
	fprintf(stdout, "\nCreated 02 July 2010 by Hank McShane\nversion 0.1\nrequires Mac OS X 10.4 or higher\n\nUse this to add an image file as the custom icon to a file or folder.\nYou can also remove the custom icon from a file/folder.\n\nUsage: SetFileIcon\n\t[-h] show the help text\n\t[-image <imagePath>] path to the image to be used for the icon\n\t[-file <filePath>] path to the file to set the icon\n\t[-removeCustomIcon] removes the custom icon for the file\n\nExamples:\nThis sets the image as the custom icon for the file:\n\tSetFileIcon -image /path/to/image -file /path/to/file\n\nThis removes the custom icon from the file:\n\tSetFileIcon -removeCustomIcon -file /path/to/file\n\n");
}
