//
//  main.m
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import "MySotrter.h"
#import <stdlib.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray* array = [NSMutableArray arrayWithObjects: @"125",@"1234",@"11",@"asd",@"qsf",@"qwrc",@"qwer",@"as21",nil];
        
        
//        [MySorter selectSort:array withComparator:^BOOL(NSString* o1, NSString* o2) {
//            int res = strcmp([o1 UTF8String], [o2 UTF8String]);
//            return res > 0;
//        }];
//        [MySorter quickSort:array withComparator:^BOOL(NSString* o1, NSString* o2) {
//            int res = strcmp([o1 UTF8String], [o2 UTF8String]);
//            return res > 0;
//        }];
        [MySorter heapSort:array withComparator:^BOOL(id o1, id o2) {
            int res = strcmp([o1 UTF8String], [o2 UTF8String]);
            return res > 0;
        }];
        NSLog(@"%@",array);
    }
    return 0;
}
