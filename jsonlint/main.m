//
//  main.m
//  jsonlint
//
//  Created by James Addyman on 29/10/2014.
//  Copyright (c) 2014 Jamsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        if (argc != 2)
        {
            fprintf(stderr, "Usage: %s </path/to/json/file> or '<jsonstring>'\n", argv[0]);
            return 0;
        }
        
        NSData *jsonData = nil;
        
        NSString *firstArg = [NSString stringWithUTF8String:argv[1]];
        if ([firstArg hasPrefix:@"["] || [firstArg hasPrefix:@"{"])
        {
            // it's a json string
            jsonData = [firstArg dataUsingEncoding:NSUTF8StringEncoding];
        }
        else
        {
            // try a file path
            if (![[NSFileManager defaultManager] fileExistsAtPath:firstArg])
            {
                fprintf(stderr, "%s no such file\n", argv[1]);
                return 0;
            }
            
            jsonData = [NSData dataWithContentsOfFile:firstArg];
        }
        
        if (!jsonData)
        {
            fprintf(stderr, "Unable to read file at %s\n", argv[1]);
            return 0;
        }
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!jsonObject && error)
        {
            fprintf(stderr, "Error reading json: %s\n", [[error localizedDescription] UTF8String]);
            return 0;
        }
        
        error = nil;
        NSData *prettyJSONData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
        if (!prettyJSONData && error)
        {
            fprintf(stderr, "Error writing json: %s\n", [[error localizedDescription] UTF8String]);
            return 0;
        }
        
        fprintf(stdout, "%s\n\r", [[[NSString alloc] initWithData:prettyJSONData encoding:NSUTF8StringEncoding] UTF8String]);
    }
    return 0;
}
