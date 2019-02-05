With Ada.Unchecked_Deallocation, Ada.Text_IO; use Ada.Text_IO;

package body BinarySearchTree is
   HeadPt: BinarySearchTreePoint:= new Node;

   procedure InsertBinarySearchTree(AKey: Key; Info: BinarySearchTreeRecord) is
      P, Q: BinarySearchTreePoint;
   begin
      if HeadPt.LLink = HeadPt then
         AllocateNode(Q, Info);
         HeadPt.LLink:= Q; HeadPt.LTag:= True;
         Q.RLink:= HeadPt; Q.RTag:= False;
         Q.LLink:= HeadPt; Q.LTag:= False;
      else
         P:= HeadPt.LLink;
         loop
            if AKey < P.info then
               if P.LTag /= False then
                  P:= P.LLink;
               else
                  AllocateNode(Q, Info);
                  Q.LLink:= P.LLink; Q.LTag:= P.LTag;
                  P.LLink:= Q; P.LTag:= True;
                  Q.RLink:= P; Q.RTag:= False;
                  goto ExitLoop;
               end if;
            else if AKey > P.info then
                  if P.RTag /= false then
                     P:= P.RLink;
                  else
                     AllocateNode(Q, Info);
                     Q.RLink:= P.RLink; Q.RTag:= P.RTag;
                     P.RLink:= Q; P.RTag:= True;
                     Q.LLink:= P; Q.LTag:= False;
                     goto ExitLoop;
                  end if;
               else
                  AllocateNode(Q, Info);
                  Q.RLink:= P.RLink;
                  Q.RTag:= P.RTag;
                  Q.LLink:= P;
                  Q.LTag:= False;
                  P.RLink:= Q;
                  P.RTag:= True;
                  goto ExitLoop;
               end if;
            end if;
         end loop;

      end if;
      <<ExitLoop>>
      Size:= Size +1;
   end InsertBinarySearchTree;

   procedure DeleteRandomNode(DP: in out BinarySearchTreePoint; Parent: in out BinarySearchTreePoint) is
      -- Parent node found in binary search to simplify this problem
      -- need to find everything pointing to "DP" whether a link or a thread
      -- 3 mutually exclusive Cases:
           -- Case 1: "DP" has no children
           -- Case 2: "DP" has one child
           -- Case 3: "DP" has two children
      -- and if "Parent" is the head node/ "DP" is the root node
           --(checked regardless of the previous case result)

      procedure NoChildren(DP: BinarySearchTreePoint; Parent: BinarySearchTreePoint) is
         procedure Free is new Ada.Unchecked_Deallocation(Node, BinarySearchTreePoint);
         T: BinarySearchTreePoint:= DP;
      begin

         -- check if the node to be deleted is the root of the tree, then
         -- if the node to be deleted is not the root check the left and right
         -- links of the parent to find which points to DP
         If Parent = HeadPt then
            HeadPt.LLink:= HeadPt; HeadPt.LTag:= False;
         else if Parent.LLink = DP then
               Parent.LLink:= DP.LLink; -- assign the left thread of the node to be deleted
               Parent.LTag:= False;     -- to its parents left link and correct the tag
            else -- Parent.RLink = DP
               Parent.RLink:= DP.RLink; -- assign the right thread of the node to be deleted
               Parent.RTag:= False;     -- to its parents right link and correct the tag
            end if;
         end if;
         Free(T);
      end NoChildren;

      procedure OneChild(DP: BinarySearchTreePoint; Parent: BinarySearchTreePoint) is
         procedure Free is new Ada.Unchecked_Deallocation(Node, BinarySearchTreePoint);
         P, S, R, T: BinarySearchTreePoint;
      begin
         T:= DP;
         -- save the inorder predecessor and successor of DP
         P:= InOrderPredecessor(DP);
         S:= InOrderSuccessor(DP);

         -- if the left link is the one with a child then
         -- save the child of DP and fix the right thread currently pointing to
         -- DP so it points to the inorder successor of DP adjusting for
         -- the Deletion of DP
         If DP.LTag = True then
            R:= DP.LLink;
            P.RLink:= S;
         else -- DP.RTag = True
              -- Do the opposite of above to achieve the same goal
            R:= DP.RLink;
            S.LLink:= P;
         end if;

         -- check if the node to be deleted is the root, if the node is not
         -- the root then check both links of Parent to find DP, then assign
         -- the child of DP to the link pointing to DP on the Parent
         If Parent = HeadPt then
            HeadPt.LLink:= R;
         else if Parent.LLink = DP then
               Parent.LLink:= R;
            else -- Parent.RLink = DP
               Parent.RLink:= R;
            end if;
         end if;
         Free(T);

   end OneChild;

      procedure TwoChildren(DP: BinarySearchTreePoint; Parent: BinarySearchTreePoint) is

         P, S: BinarySearchTreePoint;
      begin

         -- transverse the tree to find the inorder successor of DP and its parent
         P:= DP; S:= DP.RLink;
         while S.LTag /= False loop
            P:= S;
            S:= S.LLink;
         end loop;

         -- exchange the info fields of DP and its inorder successor
         -- then pass the inorder successor and its parent to either
         -- case1 or case2 as the node to be deleted now has one or no children
         DP.info:= S.info;
         if S.LTag = False and S.RTag = False then
            NoChildren(S, P);
         else
            OneChild(S, P);
         end if;

      end TwoChildren;

   begin
      if DP = null then
         Put_Line("The name to be deleted was not found in the tree."); New_Line;
      else
         Put("Deleted: "); PrintName(DP.info); New_Line; New_Line;
         if DP.RTag = True and DP.LTag = True then -- two children: Case 3
            TwoChildren(DP, Parent);
         else if DP.RTag = True xor DP.LTag = True then -- one child Case 2
               OneChild(DP, Parent);
            else -- No children Case 1
               NoChildren(DP, Parent);
            end if;
         end if;
         Size:= Size -1;
      end if;


   end DeleteRandomNode;


   procedure FindCustomerIterative(Name: in Key;
                                   Pt: out BinarySearchTreePoint;
                                   Parent: out BinarySearchTreePoint) is
      P: BinarySearchTreePoint:= HeadPt.LLink;
   begin
      Parent:= HeadPt;
      loop
         if P = HeadPt then
            Put_Line("The tree is empty! ");
            Pt:= null; Parent:= null;
            goto Found;
         else if Name < P.info then
               If P.LTag = False then
                  Pt:= null; Parent:= null;
                  goto Found;
               end if;
               Parent:= P;
               P:= P.LLink;
            else if Name > P.info then
                  If P.RTag = False then
                     Pt:= null; Parent:= null;
                     goto Found;
                  end if;
                  Parent:= P;
                  P:= P.RLink;
               else if Name = P.info then
                     Pt:= P;
                     goto Found;
                  end if;
               end if;
            end if;
         end if;
      end loop;
      <<Found>>
   end FindCustomerIterative;

   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint;
                                   Name: in Key;
                                   Pt: out BinarySearchTreePoint;
                                   Parent: out BinarySearchTreePoint) is

      begin
      If Name < Root.info then
         If Root.LTag = False then
            Pt:= null; Parent:= Null;
            goto Found;
         end if;
         Parent:= Root;
         FindCustomerRecursive(Root.LLink, Name, Pt, Parent);
      else if Name > Root.info then
            If Root.RTag = False then
               Pt:= Null; Parent:= null;
               goto Found;
            end if;
            Parent:= Root;
            FindCustomerRecursive(Root.RLink, Name, Pt, Parent);
         else if Name = Root.Info then
               Pt:= Root;
            end if;
         end if;
      end if;
      <<Found>>

   end FindCustomerRecursive;

   function InOrderSuccessor(TreePoint: in BinarySearchTreePoint)
                             return BinarySearchTreePoint is -- Iterative
      Q: BinarySearchTreePoint;
   begin
      Q:= TreePoint.RLink;
      if TreePoint.RTag = False then
         return Q;
      else
         while Q.LTag = True loop
               Q:= Q.LLink;
         end loop;
         return Q;
         end if;

   end InOrderSuccessor;

   function InOrderPredecessor(TreePoint: in BinarySearchTreePoint)
                               return BinarySearchTreePoint is
      Q: BinarySearchTreePoint;
   begin
      Q:= TreePoint.LLink;
      if TreePoint.LTag = False then
         return Q;
      else
         while Q.RTag = True loop
            Q:= Q.RLink;
         end loop;
         return Q;
      end if;

   end InOrderPredecessor;

   procedure InOrderNames(Ptr: BinarySearchTreePoint) is
      Q: BinarySearchTreePoint:= Ptr;
   begin
      Put_Line("Tree InOrder:"); Put("   ");
      For I in 1..Size loop
         If Q /= HeadPt then
            PrintName(Q.info);
            Q:= InOrderSuccessor(Q);
         else
            Q:= InOrderSuccessor(Q);
            PrintName(Q.info);
            Q:= InOrderSuccessor(Q);
         end if;
      end loop;
      New_Line;
   end InOrdernames;

   procedure InOrderBoth(Ptr: BinarySearchTreePoint) is
      Q: BinarySearchTreePoint:= Ptr;
   begin
      Put_Line("Tree InOrder:"); Put("   ");
      For I in 1..Size loop
         If Q /= HeadPt then
            PrintName(Q.info); PrintPhone(Q.Info);
            Q:= InOrderSuccessor(Q);
         else
            Q:= InOrderSuccessor(Q);
            PrintName(Q.info); PrintPhone(Q.info);
            Q:= InOrderSuccessor(Q);
         end if;
      end loop;
      New_Line;
      end InOrderBoth;

   procedure PreOrder is
      Q: BinarySearchTreePoint:= HeadPt.LLink;
   begin
      Put_Line("Tree PreOrder:"); Put("   ");
      PrintName(Q.info);
      For I in 1..Size-1 loop
         if Q.LTag = True then
            Q:= Q.LLink;
         else
            while Q.RTag /= True loop
               Q:= Q.RLink;
            end loop;
            Q:= Q.RLink;
         end if;
         PrintName(Q.info);
      end loop;
      New_Line;

   end PreOrder;

   procedure PostOrderIterative is
      Q: BinarySearchTreePoint:= HeadPt.LLink;
      List: Array(1..Size) of BinarySearchTreePoint;
   begin
      Put_Line("Tree PostOrder (Iterative): "); Put("   ");
      If Size = 0 then
         Put_Line("The tree is empty!");
      else
         List(1):= Q;
         for I in 2..Size loop
            if Q.RTag = True then
               Q:= Q.RLink;
            else
               while Q.LTag /= True loop
                  Q:= Q.LLink;
               end loop;
               Q:= Q.LLink;
            end if;
            List(I):= Q;
         end loop;
         for I in reverse 1..Size loop
            PrintName(List(I).info);
         end loop;
         New_Line;
      end if;

   end PostOrderIterative;

   procedure PostOrderRecursive(TreePoint: in out BinarySearchTreePoint) is -- Recursive

   begin
      if TreePoint.LTag /= False then
         PostOrderRecursive(TreePoint.LLink);
      end if;
      if TreePoint.RTag /= False then
         PostOrderRecursive(TreePoint.RLink);
      end if;
      PrintName(TreePoint.info);

   end PostOrderRecursive;

   procedure ReverseInOrder(TreePoint: in BinarySearchTreePoint) is -- must be recursive

   begin

      If TreePoint.RTag /= False then
         ReverseInOrder(TreePoint.RLink);
      end if;
      PrintName(TreePoint.info); PrintPhone(TreePoint.info);
      if TreePoint.LTag /= False then
         ReverseInOrder(TreePoint.LLink);
      end if;

   end ReverseInOrder;

   procedure AllocateNode(Q: out BinarySearchTreePoint; Info: in BinarySearchTreeRecord) is begin
      Q:= new Node; Q.info:= Info; Q.LLink:= null; Q.RLink:= null;
      Q.LTag:= False; Q.RTag:= False;

   end AllocateNode;

   procedure RootNode(TheRoot: out BinarySearchTreePoint)is begin
      TheRoot:= HeadPt.LLink;

   end RootNode;

   function CustomerName(TreePoint: in BinarySearchTreePoint) return Key is
   begin
      return Name(TreePoint.info);

   end CustomerName;


   function CustomerPhone(TreePoint: in BinarySearchTreePoint) return key is
   begin
      return Phone(TreePoint.info);

   end CustomerPhone;

   function Not_Null(TreePoint: BinarySearchTreePoint) return boolean is
   begin
      If TreePoint = Null then
         return False;
      else
         return True;
      end if;

   end Not_Null;


begin
   HeadPt.LLink:= HeadPt;
   HeadPt.RLink:= HeadPt;
   HeadPt.RTag:= True;
   HeadPt.LTag:= False;

end BinarySearchTree;
