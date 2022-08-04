//
//  main.m
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import "MySotrter.h"
#import <stdlib.h>
#import "BTree.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray* array = [NSMutableArray arrayWithObjects: @"125",@"1234",@"11",@"asd",@"qsf",@"qwrc",@"qwer",@"as21",nil];
        
        ///排序算法测试
//        [MySorter selectSort:array withComparator:^BOOL(NSString* o1, NSString* o2) {
//            int res = strcmp([o1 UTF8String], [o2 UTF8String]);
//            return res > 0;
//        }];
//        [MySorter quickSort:array withComparator:^BOOL(NSString* o1, NSString* o2) {
//            int res = strcmp([o1 UTF8String], [o2 UTF8String]);
//            return res > 0;
//        }];
//        [MySorter heapSort:array withComparator:^BOOL(id o1, id o2) {
//            int res = strcmp([o1 UTF8String], [o2 UTF8String]);
//            return res > 0;
//        }];
//        NSLog(@"%@",array);
        
        /// 二叉树测试
        NSArray * preOrder =@[@1,@2,@4,@3,@5,@6];
        NSArray * inOrder = @[@4,@2,@1,@5,@3,@6];
        
        BTree * tree = [[BTree alloc]initTreeWithPreOrderTravelse:preOrder andInOrderTraverse:inOrder];
        [tree postOrderTraverse];
    }
    return 0;
}
