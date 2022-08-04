//
//  BTree.h
//  CampWorkPro01
//
//  Created by ByteDance on 2022/8/3.
//


@interface BNode : NSObject

// 节点储存的数据
@property(nonatomic,strong) id _Nullable elem;
// 节点的左右子树
@property(nonatomic,strong) BNode* _Nullable lChild;
@property(nonatomic,strong) BNode* _Nullable rChild;

@end

/// 二叉树的表示类
@interface BTree : NSObject
// 使用链表表示二叉树
@property (nonatomic,strong) BNode* _Nullable root; //二叉树的根节点

// 创建二叉树
- (instancetype _Nullable ) initTreeWithPreOrderTravelse:(NSArray *) preOrder andInOrderTraverse:(NSArray *) inOrder;

// 后序遍历二叉树
-(void) postOrderTraverse;

@end
