//
//  main.m
//  ListNode
//
//  Created by Chris Zhong on 2018/12/15.
//  Copyright © 2018年 Chris Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

struct ListNode {
    int val;
    struct ListNode *next;
};

struct ListNode * initListNode(int val) {
    struct ListNode *new = (struct ListNode *)malloc(sizeof(struct ListNode));
    new->val = val;
    new->next = NULL;
    return new;
}

void printListNode(struct ListNode *node) {
    printf(">>>%d", node->val);
    node = node->next;
    if (node != NULL) {
        printListNode(node);
    } else {
        printf("\n");
    }
}



//相加两个链表每个相对应节点的值
struct ListNode* addTwoListNode (struct ListNode *n1, struct ListNode *n2) {
    struct ListNode *head = initListNode(0);
    struct ListNode *p = n1, *q = n2, *current = head;
    int increase = 0;
    while (p || q) {
        int x = p ? p->val : 0;
        int y = q ? q->val : 0;
        int sum = x + y + increase;
        current->next = initListNode(sum%10);
        current = current->next;
        increase = sum / 10;
        if (p) p = p->next;
        if (q) q = q->next;
    }
    if (increase > 0) {
        current->next = initListNode(increase);
    }
    
    return head->next;
}

//合并两个有序链表
struct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2) {
    if (l1 == NULL) return l2;
    if (l2 == NULL) return l1;
    struct ListNode* mergeHead = initListNode(0), * head = mergeHead;
    while (l1 && l2) {
        if (l1->val >= l2->val) {
            head->next = l2;
            l2 = l2->next;
        } else {
            head->next = l1;
            l1 = l1->next;
        }
        head = head->next;
    }
    if (l1) {
        head->next = l1;
    }
    if (l2) {
        head->next = l2;
    }
    return mergeHead->next;
}

//反转单链表
struct ListNode* reverseNode(struct ListNode *node) {
    struct ListNode *previous = NULL, *current = node, *next = current->next;
    while (next != NULL) {
        current->next = previous;
        previous = current;
        current = next;
        next = next->next;
    }
    current->next = previous;
    return current;
}

//判断是否回文链表
bool isPalindrome(struct ListNode* head) {
    //遍历加入数组，判断是否回文
    //    if (head == NULL || head->next == NULL) {
    //        return true;
    //    }
    //    int length = 0;
    //    struct ListNode* current = head;
    //    while (current != NULL) {
    //        length ++;
    //        current = current->next;
    //    }
    //    int values[length];
    //    struct ListNode* p = head;
    //    int index = 0;
    //    while (p != NULL) {
    //        values[index] = p->val;
    //        index ++;
    //        p = p->next;
    //    }
    //
    //    bool flag = true;
    //    for (int i = 0; i <= length/2; i++) {
    //        if (values[i] != values[length-1-i]) {
    //            flag = false;
    //            break;
    //        }
    //    }
    //
    //    return flag;
    
    
    //快慢指针找到中间节点，反转后半部分链表，再判断节点值是否相等
    if (head == NULL || head->next == NULL) {
        return true;
    }
    bool flag = true;
    struct ListNode* slow = head, *fast = head;
    while (fast != NULL && fast->next != NULL) {
        if (fast->next->next == NULL) {
            break;
        } else {
            slow = slow->next;
            fast = fast->next->next;
        }
    }
    struct ListNode* reverseHead = slow->next;
    struct ListNode* reversedListHead = reverseNode(reverseHead);
    while (reversedListHead != NULL && head != NULL) {
        if (reversedListHead->val != head->val) {
            flag = false;
            break;
        } else {
            reversedListHead = reversedListHead->next;
            head = head->next;
        }
    }
    return flag;
}

//删除链表中等于给定val的所有节点
struct ListNode* removeElements(struct ListNode* head, int val) {
    //    if (head == NULL) return NULL;
    //    struct ListNode* previous = NULL, * current = head, * next = head->next;
    //    while (current != NULL) {
    //        if (current->val == val) {
    //            if (previous == NULL) {
    //                return removeElements(next, val);
    //            } else {
    //                previous->next = next;
    //                current = next;
    //                if (next != NULL) {
    //                    next = next->next;
    //                } else {
    //                    break;
    //                }
    //            }
    //        } else {
    //            previous = current;
    //            current = next;
    //            if (next != NULL) {
    //                next = next->next;
    //            } else {
    //                break;
    //            }
    //        }
    //    }
    //    return head;
    
    //最优写法
    struct ListNode* p = head;
    if (p != NULL) {
        while (p != NULL && p->val == val) {
            p = p->next;
        }
        
        struct ListNode* q = p;
        while (q != NULL && q->next != NULL) {
            if (q->next->val == val) {
                q->next = q->next->next;
            } else {
                q = q->next;
            }
        }
        return p;
    } else {
        return p;
    }
}

//分隔链表
//给定一个链表和一个特定值 x，对链表进行分隔，使得所有小于 x 的节点都在大于或等于 x 的节点之前。
//你应当保留两个分区中每个节点的初始相对位置。
struct ListNode* partition(struct ListNode* head, int x) {
    if (head == NULL || head->next == NULL) return head;
    struct ListNode* smaller = initListNode(0), * smallerHead = NULL, * bigger = initListNode(0), *biggerHead = NULL;
    int smallFlag = 0, bigFlag = 0;
    while (head) {
        if (head->val < x) {
            smaller->next = head;
            if (smallFlag == 0) {
                smallerHead = head;
            }
            smaller = smaller->next;
            smallFlag ++;
        } else {
            bigger->next = head;
            if (bigFlag == 0) {
                biggerHead = head;
            }
            bigger = bigger->next;
            bigFlag ++;
        }
        head = head->next;
    }
    bigger->next = NULL;
    if (smallerHead == NULL) {
        return biggerHead;
    } else {
        smaller->next = biggerHead;
        return smallerHead;
    }
}

//相交链表
//如果两个链表没有交点，返回 null
//在返回结果后，两个链表仍须保持原有的结构
//可假定整个链表结构中没有循环
//程序尽量满足 O(n) 时间复杂度，且仅用 O(1) 内存
struct ListNode *getIntersectionNode(struct ListNode *headA, struct ListNode *headB) {
    /*
     //先将长的链表走一部分，再对比等长的两个链表第一个相等的节点
     if (headA == NULL || headB == NULL) return NULL;
     int lengthA = 0;
     struct ListNode* currentA = headA;
     while (currentA) {
     currentA = currentA->next;
     lengthA++;
     }
     
     int lengthB = 0;
     struct ListNode* currentB = headB;
     while (currentB) {
     currentB = currentB->next;
     lengthB++;
     }
     
     struct ListNode* p1 = headA;
     struct ListNode* p2 = headB;
     int padding = 0;
     if (lengthA > lengthB) {
     while (padding < lengthA - lengthB) {
     p1 = p1->next;
     padding ++;
     }
     } else if (lengthA < lengthB) {
     while (padding < lengthB - lengthA) {
     p2 = p2->next;
     padding ++;
     }
     }
     struct ListNode* intersection = NULL;
     while (p1 && p2) {
     if (p1->val == p2->val) {
     intersection = p1;
     break;
     }
     p1 = p1->next;
     p2 = p2->next;
     }
     return intersection;
     */
    
    //最优写法
    int length=0,lengthR=0;
    struct ListNode *pA=headA,*pB=headB;
    while(pA&&pB){
        length++;pA=pA->next;pB=pB->next;
    }
    if(pA)
    {
        while(pA){lengthR++;pA=pA->next;}
        pA=headA;while(lengthR--){pA=pA->next;}
    }
    else
        pA=headA;
    if(pB)
    {
        while(pB){lengthR++;pB=pB->next;}
        pB=headB;while(lengthR--){pB=pB->next;}
    }
    else
        pB=headB;
    
    while(length--){if(pA->val!=pB->val){pA=pA->next;pB=pB->next;}
        else return pA;}
    return NULL;
}

//给定一个单链表，把所有的奇数节点和偶数节点分别排在一起。请注意，这里的奇数节点和偶数节点指的是节点编号的奇偶性，而不是节点的值的奇偶性。
//请尝试使用原地算法完成。你的算法的空间复杂度应为 O(1)，时间复杂度应为 O(nodes)，nodes 为节点总数。
//应当保持奇数节点和偶数节点的相对顺序。  链表的第一个节点视为奇数节点，第二个节点视为偶数节点，以此类推。
struct ListNode* oddEvenList(struct ListNode* head) {
    /*
     if (head == NULL || head->next == NULL || head->next->next == NULL) return head;
     int index = 1;
     struct ListNode* q = initListNode(0), * qHead = q, * p = initListNode(0), * newHead = p;
     while (head) {
     if (index%2 == 0) {
     q->next = head;
     q = q->next;
     } else {
     p->next = head;
     p = p->next;
     }
     head = head->next;
     index ++;
     }
     q->next = NULL;
     p->next = qHead->next;
     return newHead->next;
     */
    
    //最优写法
    if(!head)
        return head;
    struct ListNode* odd=head,*even=head->next,*evenHead=even;
    while(even&&even->next)
    {
        odd->next=even->next;
        odd=odd->next;
        even->next=odd->next;
        even=even->next;
    }
    odd->next=evenHead;
    return head;
}

//反转链表
//反转从位置 m 到 n 的链表。请使用一趟扫描完成反转。1 ≤ m ≤ n ≤ 链表长度。
struct ListNode* reverseBetween(struct ListNode* head, int m, int n) {
    if (m == n) return head;
    
    int index = 1;
    struct ListNode* current = head, * p = NULL, * insert = NULL;
    while (index < n) {
        if (index >= m) {
            struct ListNode* t = current->next;
            current->next = current->next->next;
            if (p) p->next = t;
            if (insert != NULL) {
                t->next = insert;
            } else {
                t->next = current;
            }
            insert = t;
        } else {
            p = current;
            current = current->next;
        }
        index++;
    }
    if (m == 1) {
        return insert;
    } else {
        return head;
    }
}


//判断链表是否有环
bool hasCycle(struct ListNode *head) {
    //    if (head == NULL || head->next == NULL) {
    //        return false;
    //    }
    //    bool flag = false;
    //    struct ListNode *next = head->next, *fast = next->next;
    //    while (next != NULL && fast != NULL) {
    //        if (next->val == fast->val) {
    //            flag = true;
    //            break;
    //        }
    //        next = next->next;
    //        if (fast->next != NULL) {
    //            fast = fast->next->next;
    //        } else {
    //            break;
    //        }
    //    }
    //    return flag;
    
    //最优写法
    if(NULL == head)
        return false;
    
    struct ListNode *fast=head;
    struct ListNode *slow=head;
    while(fast&&fast->next)
    {
        fast=fast->next->next;
        slow=slow->next;
        if(fast==slow)
            return true;
    }
    return false;
}

//递归反转单链表
struct ListNode* recursiveReverseNode(struct ListNode *head) {
    if (head == NULL || head->next == NULL) {
        return head;
    }
    struct ListNode* new = recursiveReverseNode(head->next);
    head->next->next = head;
    head->next = NULL;
    return new;
}


void initList(int a[], int size, struct ListNode* head) {
    int index = 0;
    struct ListNode* p = head;
    while (index < size) {
        p->next = initListNode(a[index]);
        index++;
        p = p->next;
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int b[] = {1,2,3};
        struct ListNode *head = initListNode(1);
        initList(b, 3, head);
        printListNode(head->next);
        printListNode(reverseBetween(head->next, 2, 3));
        
        printf("\n=============\n");
        
        int a[] = {1,3,5,7,9};
        struct ListNode *headA = initListNode(1);
        initList(a, 5, headA);
        printListNode(headA->next);
        printListNode(reverseBetween(headA->next, 2, 4));
        
        printf("\n=============\n");
        
        int c[] = {2,4,6,8,10};
        struct ListNode *headC = initListNode(1);
        initList(c, 5, headC);
        printListNode(headC->next);
        printListNode(reverseBetween(headC->next, 1, 3));
        
    }
    return 0;
}
