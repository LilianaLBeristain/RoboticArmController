/**
 * Author:  Liliana Mayte Lopez Beristain
 * Date:    August 2020
 * Project: Robotic Arm Trajectory Design Using Genetic Programming
 * Owner:   Cerebral Lab
 * Purpose: This code was designed to use decision trees for a robotic arm controller.
 *          This class defines a decision tree structure and provides utility functions.
 **/
import java.util.Random;


class Tree {
    // Private constants
    private final String[] function = { "if", ">=" };
    private final String[] terminal = { "d", "constA", "constB", "constC" };
    private final float step  = 15;
    private final float score = 0;
    // Private variables
    private TreeNode root;
    private Random random;
    private int height;
    private int weight;
    
    /* Constructor */
    public Tree ( int method, int pM, Random random ) {
        this.random = random;
        createTree (method, pM);
        calculateHeight (root, 0, 0);
        calculateWeight (root);
    }

    /*
     * Print tree on log, for illustrative purposes 
     */
    public void printTree ( TreeNode node, int level ) {
        int i;

        System.out.print("|");

        for ( i = level; i < height; i++ ) {
            System.out.print("\t");
            System.out.print("----");
        }

        level--;
        
        System.out.println ( node.content );
        
        if ( node.getLeftLeaf() != null) {
            printTree(node.getLeftLeaf(), level);
        }
        
        if ( node.getRightLeaf() != null) {
            printTree(node.getRightLeaf(), level);
        }
    }
    
    /* 
     * This function calculates the weight of the tree. It could be defined as calculate
     * the number of nodes it has on the left and the right side.
     */
    public void calculateWeight(TreeNode node) {
        weight++;
        node.setID(weight);

        if(node.getLeftLeaf() != null) {
            calculateWeight( node.getLeftLeaf() );
        }

        if(node.getRightLeaf() != null) {
            calculateWeight( node.getRightLeaf() );
        }
    }
    
    /*
     * This function calculates the height of the tree. How many levels it has, and which side the weight
     * predominates.
     */
    public void calculateHeight ( TreeNode node, int nivA, int nivB ) {
        if(node.getLeftLeaf() != null)
        {
            nivA++;
            calculateHeight(node.getLeftLeaf(), nivA, nivB);
        }
        if(node.getRightLeaf() != null)
        {
            nivB++;
            calculateHeight(node.getRightLeaf(), nivA, nivB);
        }
        
        if(nivA > nivB)
            height = nivA;
        else
            height = nivB;
    }

    /*
     * Returns the father node of the tree, the root.
     */
    public TreeNode getRoot(){
        return this.root;
    }

    /* 
     * Creates the tree according to the method selected by the user
     */
    private void createTree ( int method, int pM ) {
        //System.out.println("Método: " + method);
        switch ( method ) {
            case 0:
                //FullMethod
                this.root = FullMethod(null, pM);
                break;
            case 1:
                //GrowMethod
                this.root = GrowMethod(null, pM);
                break;
            case 2:
                //M-ario Method
                this.root = MarioMethod(null, pM);
                break;
        }
    }

    /*
     * Methods for the tree creation.
     */
    private TreeNode FullMethod ( TreeNode fatherNode, int size ) {
        TreeNode nTree = new TreeNode();
        nTree.setFatherNode( fatherNode );
        if ( size <= 1 ) {
            nTree.setContent ( terminal[getRandom (terminal.length) ]);
            nTree.setType("FunctionType");
            nTree.setRightLeaf(null);
            nTree.setLeftLeaf(null);
        } else{
            nTree.setContent( Funcion[getRandom(Funcion.length) ]);
            nTree.setRightLeaf(FullMethod(nTree, size-1));
            nTree.setLeftLeaf(FullMethod(nTree, size-1));
        }
        return nTree;
    }

    private TreeNode GrowMethod( TreeNode fatherNode, int size ) {        
        int x = getRandom(2);
        TreeNode nTree = new TreeNode();
        nTree.setFatherNode(fatherNode);
        if ( size <= 0 || x == 1 ) {
            nTree.setContent ( terminal[getRandom(terminal.length)] );
            nTree.setType("FunctionType");
            nTree.setRightLeaf(null);
            nTree.setLeftLeaf(null);
        }
        else {
            nTree.setContent ( Funcion[getRandom(Funcion.length)] );
            nTree.setRightLeaf ( FullMethod(nTree, size-1) );
            nTree.setLeftLeaf ( FullMethod(nTree, size-1) );
        }
        return nTree;
    }
    
    private TreeNode MarioMethod( TreeNode fatherNode, int size ) { 
          TreeNode nTree = new TreeNode();
          nTree.setFatherNode(fatherNode);
          if ( size <= 0 ) {
            nTree.setContent( terminal[getRandom(terminal.length)] );
            nTree.setType("FunctionType");
            nTree.setRightLeaf(null);
            nTree.setLeftLeaf(null);
          }
          return nTree;
    }
    
    /* 
     * Getters and setters
     */
    private void setRoot ( TreeNode root ) {
        this.root = root;
    }

    private void setRandom ( Random random ) {
        this.random = random;
    }

    private void setWeight ( int weight ) {
        this.weight = weight;
    }

    private void setHeight ( int height ) {
        this.height = height;
    }

    private int getRandom ( int num ) {        
        return random.nextInt(num);
    }

    private int getWeight() {
        return this.weight;
    }

    private int getHeight() {
        return this.height;
    }

    private float getScore() {
        return this.score;
    }
}