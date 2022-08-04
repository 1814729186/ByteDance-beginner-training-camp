//
//  MySotrter.h
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/1.
//


@interface MySorter : NSObject



+(void) selectSort:(NSMutableArray *) array withComparator:(BOOL(^)(id o1,id o2)) comparator;

+(void) quickSort:(NSMutableArray *) array withComparator:(BOOL(^)(id,id)) comparator;

+(void) heapSort:(NSMutableArray *) array withComparator:(BOOL(^)(id,id)) comparator;

@end
