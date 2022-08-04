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



- (instancetype)initTreeWithPreOrderTravelse:(NSArray *)preOrder andInOrderTraverse:(NSArray *)inOrder{
    self = [super init];
    NSAssert(preOrder.count == inOrder.count, @"error，请保证遍历序列长度相同");
    if(self){
        self.root = [self createBTreeWithPreOrderTraverse:preOrder from:0 to:preOrder.count-1 andInOrderTraverse:inOrder from:0 to:inOrder.count-1];
    }
    return self;
}

// 创建二叉树
-(BNode* _Nullable) createBTreeWithPreOrderTraverse:(NSArray*)preOrder from:(int)preBegin to:(int)preEnd andInOrderTraverse:(NSArray *)inOrder from:(int)inBegin to:(int)inEnd {
    if(preBegin>preEnd) return nil;
    NSAssert(preEnd - preBegin == inEnd - inBegin,@"请保证遍历符合要求");
    BNode * node = [[BNode alloc]init];
    node.elem = preOrder[preBegin]; //创建当前节点
    // 在inOrder中找到preOrder[preBegin]的位置
    int inRootIndex = (int)[inOrder indexOfObject:preOrder[preBegin]];
    // 创建当前节点的左右子树
    node.lChild = [self createBTreeWithPreOrderTraverse:preOrder from:preBegin+1 to:preBegin+inRootIndex-inBegin andInOrderTraverse:inOrder from:inBegin to:inRootIndex-1];
    node.rChild = [self createBTreeWithPreOrderTraverse:preOrder from:preBegin+inRootIndex-inBegin+1 to:preEnd andInOrderTraverse:inOrder from:inRootIndex+1 to:inEnd];
    return node;
}


// 后序遍历
-(void)postOrderTraverse{
    // 向左全部入栈，当栈顶左子树为空或者已经访问时，入栈右子树
    // 栈顶节点的左右子节点为空时，出栈该节点并访问
    NSMutableArray *stack = [NSMutableArray array];
    
    [stack addObject:self.root];
    BNode * top = nil;
    BNode * pre = nil;
    BOOL flag = FALSE; //标记左子节点的访问情况
    while(stack.count != 0){
        top = [stack objectAtIndex:[stack count]-1];
        while(!flag && top.lChild){ // 左子节点全部入栈
            [stack addObject:top.lChild];
            top = top.lChild;
        }
        if(top.rChild&&top.rChild!=pre){
            [stack addObject:top.rChild];
            flag = FALSE;
            continue;
        }else{ // 左右子树均为空
            // 访问之
            NSLog(@"%@",top);
            pre = top;
            [stack removeLastObject];
            // 置访问标记
            flag = TRUE;
        }
    }
    
}


@end
