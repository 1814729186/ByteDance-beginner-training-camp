//
//  BTree.m
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/3.
//

#import <Foundation/Foundation.h>
#import "BTree.h"

@interface BNode()

@end

@implementation BNode

-(NSString *)description{
    return [NSString stringWithFormat:@"treeNode:%@",_elem];
}

@end


@interface BTree()

@end

@implementation BTree



-(BNode*) initTreeWithPreOrderTravelse:(NSArray *)preOrder from:(int)preBegin to:(int)preEnd andInOrderTraverse:(NSArray *)inOrder from:(int)inBegin to:(int)inEnd{
    // 保证相同
    if(preEnd-preBegin<=0) return nil;
    NSAssert(preEnd-preBegin == inEnd - inBegin, @"遍历结果不满足需求");
    
    // 
    
    
    
    
}

-(void)postOrderTraverse{
    
    
}


@end
