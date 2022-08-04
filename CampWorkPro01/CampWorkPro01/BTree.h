//
//  BTree.h
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/3.
//


@interface BNode : NSObject

// 节点储存的数据
@property(nonatomic,strong) id elem;
// 节点的左右子树
@property(nonatomic,strong) BNode* lChild;
@property(nonatomic,strong) BNode* rChild;

@end

/// 二叉树的表示类
@interface BTree : NSObject
// 使用链表表示二叉树


// 创建二叉树
- (BNode *) initTreeWithPreOrderTravelse:(NSArray *) preOrder from:(int)preBegin to:(int)preEnd andInOrderTraverse:(NSArray *) inOrder from:(int)inBegin to:(int)inEnd;

// 后序遍历二叉树
-(void) postOrderTraverse;

@end
