
generic
   type Key is private;
   type BinarySearchTreeRecord is private;
   with function "<"(TheKey: in Key; ARecord: in BinarySearchTreeRecord)
                     return Boolean;
   with function ">"(TheKey: in Key; ARecord: in BinarySearchTreeRecord)
                     return Boolean;
   with function "="(TheKey: in Key; ARecord: in BinarySearchTreeRecord)
                     return Boolean;
   with function Name(ARecord: in BinarySearchTreeRecord) return Key;

   with function Phone(ARecord: in BinarySearchTreeRecord) return Key;

   with procedure PrintName(ARecord: in BinarySearchTreeRecord);

   with procedure PrintPhone(ARecord: in BinarySearchTreeRecord);

package BinarySearchTree is


   type BinarySearchTreePoint is limited private;

   procedure InsertBinarySearchTree(AKey: Key; Info: BinarySearchTreeRecord);

   procedure DeleteRandomNode(DP: in out BinarySearchTreePoint; Parent: in out BinarySearchTreePoint);

   procedure FindCustomerIterative(Name: in Key;
                                   Pt: out BinarySearchTreePoint;
                                   Parent: out BinarySearchTreePoint);

   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint;
                                   Name: in Key;
                                   Pt: out BinarySearchTreePoint;
                                   Parent: out BinarySearchTreePoint);

   function InOrderSuccessor(TreePoint: in BinarySearchTreePoint)
                             return BinarySearchTreePoint;

   function InOrderPredecessor(TreePoint: in BinarySearchTreePoint)
                               return BinarySearchTreePoint;

   procedure InOrderNames(Ptr: BinarySearchTreePoint);

   procedure InOrderBoth(Ptr: BinarySearchTreePoint);

   procedure PreOrder;

   procedure PostOrderIterative;

   procedure PostOrderRecursive(TreePoint: in out BinarySearchTreePoint);

   procedure ReverseInOrder(TreePoint: in BinarySearchTreePoint);

   procedure AllocateNode(Q: out BinarySearchTreePoint; Info: BinarySearchTreeRecord);

   procedure RootNode(TheRoot: out BinarySearchTreePoint);

   function CustomerName(TreePoint: in BinarySearchTreePoint) return Key;

   function CustomerPhone(TreePoint: in BinarySearchTreePoint) return key;

   function Not_Null(TreePoint: BinarySearchTreePoint) return boolean;

   Size: Integer:= 0;

private

   type Node;
   type BinarySearchTreePoint is access Node;
   type Node is
      record
         LLink, RLink: BinarySearchTreePoint;
         LTag, RTag: boolean;
         info: BinarySearchTreeRecord;
      end record;

end BinarySearchTree;
