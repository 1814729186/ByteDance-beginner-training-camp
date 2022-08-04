//
//  MySorter.m
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import "MySotrter.h"


void swap(id *a,id *b){
    id temp = *b;
    *b = *a;
    *a = temp;
}

@interface MySorter ()

+(void) quickSort:(NSMutableArray *)array from:(int)begin to:(int) end withComparator:(BOOL (^)(id o1,id o2))comparator;

+ (void)heapAdjust:(NSMutableArray *)array from:(int)index to:(int)end withCompatator:(BOOL (^)(id, id))compatator;
@end


@implementation MySorter

/// 选择排序
+(void)selectSort:(NSMutableArray *)array withComparator:(BOOL (^)(id, id))comparator{
    // 选择排序
    for(int i = 0;i < array.count - 1;i ++){
        int temp = i;
        // 找到最小的
        for(int j = i+1;j < array.count;j++){
            if(comparator(array[temp],array[j])){
                temp = j;
            }
        }
        // swap
        id t = array[temp];
        array[temp] = array[i];
        array[i] = t;
    }
}

/// 快速排序
+ (void)quickSort:(NSMutableArray *)array withComparator:(BOOL (^)(id,id))comparator{
    [MySorter quickSort:array from:0 to:(int)array.count-1 withComparator:comparator];
}
/// 快排的内层
+(void)quickSort:(NSMutableArray *)array from:(int)begin to:(int)end withComparator:(BOOL (^)(id o1,id o2))comparator{
    if(begin >= end) return;
    id temp = array[begin];
    int low = begin,high = end;
    while(low < high){
        while(low < high && !comparator(temp,array[high]))
            high --;
        array[low] = array[high];
        while(low < high && !comparator(array[low],temp))
            low ++;
        array[high] = array[low];
    }
    array[low] = temp;
    // 递归调用
    [MySorter quickSort:array from:begin to:low-1 withComparator:comparator];
    [MySorter quickSort:array from:low+1 to:end withComparator:comparator];
    
}

/// 堆排序
+ (void)heapSort:(NSMutableArray *)array withComparator:(BOOL (^)(id,id))comparator{
    // 初始化堆结构
    int len = (int)array.count;
    for(int i = len/2;i >=0;i--){
        [self heapAdjust:array from:i to:len-1 withCompatator:comparator];
    }
    // 堆排序
    for(int i = len - 1;i > 0;i --){
        // 交换
        id temp = array[0];
        array[0] = array[i];
        array[i] = temp;
        len--;
        [self heapAdjust:array from:0 to:i-1 withCompatator:comparator];
    }
}

/// 堆调整
+ (void)heapAdjust:(NSMutableArray *)array from:(int)index to:(int)end withCompatator:(BOOL (^)(id, id))compatator{
    // 调整一个堆结构
    int child = 2*index+1,childRoot = index;
    while(child <= end){
        if(child+1 <= end && compatator(array[child+1],array[child])){
            child += 1;
        }
        if(compatator(array[childRoot],array[child])){
            return;
        }else{
            //swap
            id temp = array[childRoot];
            array[childRoot] = array[child];
            array[child] = temp;
            childRoot = child;
            child = childRoot*2+1;
        }
    }
}
@end
